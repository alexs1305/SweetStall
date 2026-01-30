import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/game_data.dart';
import '../game/game_actions.dart';
import '../game/game_state.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final gameActions = context.read<GameActions>();
    final sweets = GameData.sweets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Play'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current location: ${gameState.currentLocation.name}'),
            Text('Days left: ${gameState.daysLeft}'),
            Text('Cash: \$${gameState.player.cash.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Market',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: gameState.allLocations.map((location) {
                final isSelected = location.id == gameState.currentLocation.id;
                return OutlinedButton(
                  onPressed: isSelected
                      ? null
                      : () {
                          gameActions.setLocation(location.id);
                        },
                  child: Text(location.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Column(
              children: sweets.map((sweet) {
                final buyPrice =
                    gameState.market.priceFor(sweet.id, buying: true);
                final sellPrice =
                    gameState.market.priceFor(sweet.id, buying: false);
                final ownedQuantity =
                    gameState.player.inventoryQuantity(sweet.id);
                final canBuy = gameState.player.cash >= buyPrice;
                final canSell = ownedQuantity > 0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sweet.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Buy: \$${buyPrice.toStringAsFixed(2)}  •  Sell: \$${sellPrice.toStringAsFixed(2)}',
                        ),
                        Text('You own: $ownedQuantity'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: canBuy
                                  ? () {
                                      gameActions.buy(sweet.id, 1);
                                    }
                                  : null,
                              child: const Text('Buy 1'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: canSell
                                  ? () {
                                      gameActions.sell(sweet.id, 1);
                                    }
                                  : null,
                              child: const Text('Sell 1'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Inventory',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (gameState.player.inventory.isEmpty)
              const Text('No sweets in inventory yet.')
            else
              Column(
                children: gameState.player.inventory.entries.map(
                  (entry) {
                    final sweetName =
                        GameData.sweetsById[entry.key]?.name ?? entry.key;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        sweetName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Text('x${entry.value}'),
                    );
                  },
                ).toList(),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: gameState.isGameOver
                  ? null
                  : () async {
                      await gameActions.advanceTime();
                      if (gameState.isGameOver) {
                        if (context.mounted) {
                          Navigator.pushNamed(context, '/game_over');
                        }
                      }
                    },
              child: const Text('End day'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.popUntil(
                context,
                ModalRoute.withName('/'),
              ),
              child: const Text('Return home'),
            ),
          ],
        ),
      ),
    );
  }
}
