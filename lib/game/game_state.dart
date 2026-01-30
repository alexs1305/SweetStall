import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/game_data.dart';
import '../models/leaderboard_entry.dart';
import '../models/location.dart';
import '../models/market.dart';
import '../models/player.dart';
import '../services/leaderboard_service.dart';

class GameState extends ChangeNotifier {
  final LeaderboardService leaderboardService;
  final List<Location> locations;
  final int startingDays;
  final double startingCash;
  final Random _random;

  late Player _player;
  late Market _market;
  int _daysLeft;
  bool _isGameOver;

  GameState({
    required this.leaderboardService,
    required this.locations,
    this.startingDays = 10,
    this.startingCash = 100,
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
  }

  factory GameState.withDefaults(
    LeaderboardService leaderboardService, {
    double startingCash = 100,
    int startingDays = 10,
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

  void updateDaysLeft(int daysLeft) {
    _daysLeft = daysLeft;
    notifyListeners();
  }

  Market rollMarket(Location location) {
    return Market.fromLocation(location, random: _random);
  }

  void resetGame({double? cash, int? days}) {
    final homeLocation = locations.first;
    _player = Player(
      cash: cash ?? startingCash,
      inventory: {},
      currentLocationId: homeLocation.id,
    );
    _market = Market.fromLocation(homeLocation, random: _random);
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
}
