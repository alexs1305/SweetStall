import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/game_data.dart';
import '../models/leaderboard_entry.dart';
import '../models/location.dart';
import '../models/market.dart';
import '../models/market_event.dart';
import '../models/player.dart';
import '../services/leaderboard_service.dart';

class GameState extends ChangeNotifier {
  final LeaderboardService leaderboardService;
  final List<Location> locations;
  final int startingDays;
  final double startingCash;
  final Random _random;
  static const double _marketEventChance = 0.2;
  static const double _crashMultiplierMin = 0.55;
  static const double _crashMultiplierMax = 0.8;
  static const double _surgeMultiplierMin = 1.25;
  static const double _surgeMultiplierMax = 1.6;

  late Player _player;
  late Market _market;
  MarketEvent? _marketEvent;
  int _marketEventCounter = 0;
  int _daysLeft;
  bool _isGameOver;

  GameState({
    required this.leaderboardService,
    required this.locations,
    this.startingDays = 20,
    this.startingCash = 20,
    Random? random,
  })  : _random = random ?? Random(),
        _daysLeft = startingDays,
        _isGameOver = false {
    assert(locations.isNotEmpty, 'At least one location is required');
    final initialLocation = locations.first;
    _player = Player(
      cash: startingCash,
      inventory: {},
      currentLocationId: initialLocation.id,
    );
    _market = Market.fromLocation(initialLocation, random: _random);
    _marketEvent = null;
  }

  factory GameState.withDefaults(
    LeaderboardService leaderboardService, {
    double startingCash = 20,
    int startingDays = 20,
    Random? random,
  }) {
    return GameState(
      leaderboardService: leaderboardService,
      locations: GameData.locations,
      startingCash: startingCash,
      startingDays: startingDays,
      random: random,
    );
  }

  Player get player => _player;

  Market get market => _market;

  MarketEvent? get marketEvent => _marketEvent;

  int get daysLeft => _daysLeft;

  bool get isGameOver => _isGameOver;

  List<Location> get allLocations => List.unmodifiable(locations);

  Location get currentLocation => locations.firstWhere(
        (location) => location.id == _player.currentLocationId,
        orElse: () => locations.first,
      );

  double get finalScore => _player.cash;

  void updatePlayer(Player player) {
    _player = player;
    notifyListeners();
  }

  void updateMarket(Market market) {
    _market = market;
    notifyListeners();
  }

  void updateMarketWithEvent(Market market, MarketEvent? event) {
    _market = market;
    _marketEvent = event;
    notifyListeners();
  }

  void updateDaysLeft(int daysLeft) {
    _daysLeft = daysLeft;
    notifyListeners();
  }

  Market rollMarket(Location location) {
    return Market.fromLocation(location, random: _random);
  }

  MarketEvent? rollMarketEvent(Location location) {
    final sweetIds = location.availableSweetIds;
    if (sweetIds.isEmpty) return null;
    if (_random.nextDouble() > _marketEventChance) return null;

    final sweetId = sweetIds[_random.nextInt(sweetIds.length)];
    final isCrash = _random.nextBool();
    final multiplier = isCrash
        ? _sampleMultiplier(_crashMultiplierMin, _crashMultiplierMax)
        : _sampleMultiplier(_surgeMultiplierMin, _surgeMultiplierMax);
    final type = isCrash ? MarketEventType.crash : MarketEventType.shortage;
    _marketEventCounter += 1;

    return MarketEvent(
      id: _marketEventCounter,
      sweetId: sweetId,
      type: type,
      priceMultiplier: multiplier,
      occurredAt: DateTime.now(),
    );
  }

  void resetGame({double? cash, int? days}) {
    final homeLocation = locations.first;
    _player = Player(
      cash: cash ?? startingCash,
      inventory: {},
      currentLocationId: homeLocation.id,
    );
    _market = Market.fromLocation(homeLocation, random: _random);
    _marketEvent = null;
    _daysLeft = days ?? startingDays;
    _isGameOver = false;
    notifyListeners();
  }

  Future<void> markGameOver() async {
    if (_isGameOver) return;
    _isGameOver = true;
    notifyListeners();
    await leaderboardService.addScore(
      LeaderboardEntry(score: _player.cash.round(), date: DateTime.now()),
    );
  }

  double _sampleMultiplier(double min, double max) {
    return min + (max - min) * _random.nextDouble();
  }
}
