import 'dart:math';

import '../game/game_state.dart';
import '../models/location.dart';

class GameActions {
  final GameState gameState;

  GameActions(this.gameState);

  bool setLocation(String locationId) {
    if (gameState.isGameOver) return false;
    Location? target;
    for (final location in gameState.allLocations) {
      if (location.id == locationId) {
        target = location;
        break;
      }
    }
    if (target == null ||
        target.id == gameState.player.currentLocationId) {
      return false;
    }

    gameState.updatePlayer(
      gameState.player.copyWith(currentLocationId: target.id),
    );
    gameState.updateMarket(gameState.rollMarket(target));
    return true;
  }

  bool buy(String sweetId, int quantity) {
    if (gameState.isGameOver || quantity <= 0) return false;
    final price = gameState.market.priceFor(sweetId, buying: true);
    final totalCost = price * quantity;
    if (gameState.player.cash < totalCost) return false;

    final updatedInventory = Map<String, int>.from(gameState.player.inventory);
    updatedInventory[sweetId] =
        (updatedInventory[sweetId] ?? 0) + quantity;

    final updatedPlayer = gameState.player.copyWith(
      cash: gameState.player.cash - totalCost,
      inventory: updatedInventory,
    );
    gameState.updatePlayer(updatedPlayer);
    return true;
  }

  bool sell(String sweetId, int quantity) {
    if (gameState.isGameOver || quantity <= 0) return false;
    final currentQuantity = gameState.player.inventoryQuantity(sweetId);
    if (currentQuantity < quantity) return false;

    final updatedInventory = Map<String, int>.from(gameState.player.inventory);
    final remaining = currentQuantity - quantity;
    if (remaining > 0) {
      updatedInventory[sweetId] = remaining;
    } else {
      updatedInventory.remove(sweetId);
    }

    final revenue = gameState.market.priceFor(sweetId, buying: false) * quantity;
    final updatedPlayer = gameState.player.copyWith(
      cash: gameState.player.cash + revenue,
      inventory: updatedInventory,
    );
    gameState.updatePlayer(updatedPlayer);
    return true;
  }

  Future<void> advanceTime() async {
    if (gameState.isGameOver) return;
    final nextDays = max(0, gameState.daysLeft - 1);
    gameState.updateDaysLeft(nextDays);
    if (nextDays == 0) {
      await gameState.markGameOver();
    }
  }
}
