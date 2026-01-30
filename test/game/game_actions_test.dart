import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/data/game_data.dart';
import 'package:sweetstall/game/game_actions.dart';
import 'package:sweetstall/game/game_state.dart';
import 'package:sweetstall/models/leaderboard_entry.dart';
import 'package:sweetstall/services/leaderboard_service.dart';

class FakeLeaderboardService implements LeaderboardService {
  final List<LeaderboardEntry> _entries = [];

  @override
  int get maxEntries => 10;

  @override
  List<LeaderboardEntry> loadTopScores() => List.unmodifiable(_entries);

  @override
  Future<List<LeaderboardEntry>> addScore(LeaderboardEntry entry) async {
    _entries.add(entry);
    _entries.sort((a, b) => b.score.compareTo(a.score));
    return List.unmodifiable(_entries);
  }
}

void main() {
  late GameState gameState;
  late GameActions gameActions;
  late FakeLeaderboardService fakeLeaderboard;

  setUp(() {
    fakeLeaderboard = FakeLeaderboardService();
    gameState = GameState.withDefaults(
      fakeLeaderboard,
      startingCash: 100,
      startingDays: 5,
      random: Random(42),
    );
    gameActions = GameActions(gameState);
  });

  group('GameActions.setLocation', () {
    test('returns false for same location', () async {
      final currentId = gameState.player.currentLocationId;
      expect(await gameActions.setLocation(currentId), isFalse);
    });

    test('returns false for invalid location id', () async {
      expect(await gameActions.setLocation('nonexistent'), isFalse);
    });

    test('updates player and market when moving to another location', () async {
      final other = GameData.locations
          .firstWhere((l) => l.id != gameState.player.currentLocationId);
      final oldMarketId = gameState.market.locationId;
      expect(gameState.daysLeft, 5);
      expect(await gameActions.setLocation(other.id), isTrue);
      expect(gameState.player.currentLocationId, other.id);
      expect(gameState.market.locationId, other.id);
      expect(gameState.market.locationId, isNot(equals(oldMarketId)));
      expect(gameState.daysLeft, 4);
    });
  });

  group('GameActions.buy', () {
    test('returns false when quantity <= 0', () {
      expect(gameActions.buy('bubble', 0), isFalse);
      expect(gameActions.buy('bubble', -1), isFalse);
    });

    test('returns false when insufficient cash', () {
      gameState.updatePlayer(gameState.player.copyWith(cash: 0));
      expect(gameActions.buy('bubble', 1), isFalse);
    });

    test('updates cash and inventory on success', () {
      final price = gameState.market.priceFor('bubble', buying: true);
      final beforeCash = gameState.player.cash;
      expect(gameActions.buy('bubble', 2), isTrue);
      expect(gameState.player.cash, beforeCash - price * 2);
      expect(gameState.player.inventoryQuantity('bubble'), 2);
    });

    test('returns false when game over', () async {
      await gameState.markGameOver();
      expect(gameActions.buy('bubble', 1), isFalse);
    });
  });

  group('GameActions.sell', () {
    test('returns false when quantity <= 0', () {
      expect(gameActions.sell('bubble', 0), isFalse);
    });

    test('returns false when insufficient stock', () {
      expect(gameActions.sell('bubble', 1), isFalse);
    });

    test('updates cash and inventory on success', () {
      gameActions.buy('bubble', 3);
      final sellPrice = gameState.market.priceFor('bubble', buying: false);
      final beforeCash = gameState.player.cash;
      expect(gameActions.sell('bubble', 2), isTrue);
      expect(gameState.player.cash, beforeCash + sellPrice * 2);
      expect(gameState.player.inventoryQuantity('bubble'), 1);
    });

    test('removes sweet from inventory when selling all', () {
      gameActions.buy('bubble', 1);
      gameActions.sell('bubble', 1);
      expect(gameState.player.inventoryQuantity('bubble'), 0);
      expect(gameState.player.inventory.containsKey('bubble'), isFalse);
    });

    test('returns false when game over', () async {
      gameActions.buy('bubble', 1);
      await gameState.markGameOver();
      expect(gameActions.sell('bubble', 1), isFalse);
    });
  });

  group('GameActions.advanceTime', () {
    test('decrements days left', () async {
      expect(gameState.daysLeft, 5);
      await gameActions.advanceTime();
      expect(gameState.daysLeft, 4);
    });

    test('when days reach 0, marks game over and adds score', () async {
      for (int i = 0; i < 5; i++) {
        await gameActions.advanceTime();
      }
      expect(gameState.daysLeft, 0);
      expect(gameState.isGameOver, isTrue);
      expect(fakeLeaderboard.loadTopScores().length, 1);
    });

    test('does nothing when already game over', () async {
      await gameState.markGameOver();
      final scoresBefore = fakeLeaderboard.loadTopScores().length;
      await gameActions.advanceTime();
      expect(gameState.daysLeft, 5);
      expect(fakeLeaderboard.loadTopScores().length, scoresBefore);
    });
  });
}
