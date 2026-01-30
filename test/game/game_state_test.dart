import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/data/game_data.dart';
import 'package:sweetstall/game/game_state.dart';
import 'package:sweetstall/models/leaderboard_entry.dart';
import 'package:sweetstall/models/location.dart';
import 'package:sweetstall/models/player.dart';
import 'package:sweetstall/services/leaderboard_service.dart';

class FakeLeaderboardService implements LeaderboardService {
  final List<LeaderboardEntry> _entries = [];
  int addScoreCallCount = 0;

  FakeLeaderboardService([List<LeaderboardEntry>? initial])
      : assert(initial == null || initial.isEmpty, 'use empty list') {
    if (initial != null) _entries.addAll(initial);
  }

  @override
  int get maxEntries => 10;

  @override
  List<LeaderboardEntry> loadTopScores() => List.unmodifiable(_entries);

  @override
  Future<List<LeaderboardEntry>> addScore(LeaderboardEntry entry) async {
    addScoreCallCount++;
    _entries.add(entry);
    _entries.sort((a, b) => b.score.compareTo(a.score));
    return List.unmodifiable(_entries);
  }
}

void main() {
  group('GameState', () {
    test('initial state has correct player cash and days', () {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(
        fake,
        startingCash: 100,
        startingDays: 10,
        random: Random(0),
      );
      expect(state.player.cash, 100);
      expect(state.daysLeft, 10);
      expect(state.player.inventory, isEmpty);
      expect(state.isGameOver, isFalse);
    });

    test('initial state uses first location and market for it', () {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(fake, random: Random(0));
      expect(state.currentLocation.id, GameData.locations.first.id);
      expect(state.market.locationId, state.currentLocation.id);
    });

    test('withDefaults uses GameData.locations', () {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(fake, random: Random(0));
      expect(state.allLocations, GameData.locations);
    });

    test('resetGame restores player and days', () {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(
        fake,
        startingCash: 50,
        startingDays: 5,
        random: Random(0),
      );
      state.updatePlayer(state.player.copyWith(cash: 0));
      state.updateDaysLeft(0);
      state.resetGame();
      expect(state.player.cash, 50);
      expect(state.daysLeft, 5);
      expect(state.player.inventory, isEmpty);
      expect(state.isGameOver, isFalse);
    });

    test('resetGame with args uses provided cash and days', () {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(
        fake,
        startingCash: 100,
        startingDays: 10,
        random: Random(0),
      );
      state.resetGame(cash: 200, days: 3);
      expect(state.player.cash, 200);
      expect(state.daysLeft, 3);
    });

    test('rollMarket returns new market for given location', () {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(fake, random: Random(0));
      final other = GameData.locations[1];
      final market = state.rollMarket(other);
      expect(market.locationId, other.id);
      expect(market.buyPrices, isNotEmpty);
    });

    test('markGameOver sets isGameOver and calls leaderboard addScore once', () async {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(
        fake,
        startingCash: 75.5,
        startingDays: 1,
        random: Random(0),
      );
      expect(fake.addScoreCallCount, 0);
      await state.markGameOver();
      expect(state.isGameOver, isTrue);
      expect(fake.addScoreCallCount, 1);
      final scores = fake.loadTopScores();
      expect(scores.length, 1);
      expect(scores.first.score, 76); // rounded from 75.5
    });

    test('markGameOver is idempotent', () async {
      final fake = FakeLeaderboardService();
      final state = GameState.withDefaults(fake, startingCash: 50, random: Random(0));
      await state.markGameOver();
      await state.markGameOver();
      expect(fake.addScoreCallCount, 1);
    });

    test('custom locations are used when provided', () {
      final fake = FakeLeaderboardService();
      final customLocations = [
        Location(
          id: 'only',
          name: 'Only Market',
          sweetPriceRanges: {},
        ),
      ];
      final state = GameState(
        leaderboardService: fake,
        locations: customLocations,
        startingDays: 7,
        startingCash: 200,
        random: Random(0),
      );
      expect(state.allLocations.length, 1);
      expect(state.currentLocation.id, 'only');
    });
  });
}
