import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/game_data.dart';
import '../game/game_actions.dart';
import '../game/game_state.dart';
import '../models/market_event.dart';
import '../widgets/in_game_summary.dart';

const Map<String, Color> _sweetCardColors = {
  'bubble': Color(0xFFFFF3E0),
  'caramel': Color(0xFFFFF8E1),
  'mint': Color(0xFFE8F5E9),
  'berry': Color(0xFFF3E5F5),
};
const Color _buyFillColor = Color(0xFFBBDEFB);
const Color _buyTextColor = Color(0xFF0D47A1);
const Color _sellAccentColor = Color(0xFFEF9A9A);
const Color _locationAccentColor = Color(0xFF90CAF9);
const Color _eventCrashColor = Color(0xFFEF9A9A);
const Color _eventSurgeColor = Color(0xFF81C784);

Future<void> _showMarketEventDialog(
  BuildContext context,
  GameState gameState,
  MarketEvent event,
) async {
  final sweetName = GameData.sweetsById[event.sweetId]?.name ?? 'This sweet';
  final percentChange = ((event.priceMultiplier - 1) * 100).round().abs();
  final direction = event.isPriceIncrease ? 'higher' : 'lower';
  final title =
      event.type == MarketEventType.crash ? 'Market crash!' : 'Demand surge!';

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          '$sweetName prices are $percentChange% $direction in '
          '${gameState.currentLocation.name}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      );
    },
  );
}

String _eventLabel(MarketEventType type) {
  return type == MarketEventType.crash ? 'Crash' : 'Surge';
}

IconData _eventIcon(MarketEventType type) {
  return type == MarketEventType.crash ? Icons.trending_down : Icons.trending_up;
}

Color _eventColor(MarketEventType type) {
  return type == MarketEventType.crash ? _eventCrashColor : _eventSurgeColor;
}

class _MarketEventBadge extends StatelessWidget {
  const _MarketEventBadge({required this.event});

  final MarketEvent event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _eventIcon(event.type),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            _eventLabel(event.type),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final gameActions = context.read<GameActions>();
    final sweets = GameData.sweets;
    final buyButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled)
            ? _buyFillColor.withOpacity(0.5)
            : _buyFillColor,
      ),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled)
            ? _buyTextColor.withOpacity(0.5)
            : _buyTextColor,
      ),
    );
    ButtonStyle outlinedIntentStyle(Color color) {
      return ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? color.withOpacity(0.4)
              : color,
        ),
        side: MaterialStateProperty.resolveWith(
          (states) {
            final resolved = states.contains(MaterialState.disabled)
                ? color.withOpacity(0.3)
                : color;
            return BorderSide(color: resolved);
          },
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => gameState.isGameOver,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Play'),
          automaticallyImplyLeading: false,
        ),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: InGameSummary(gameState),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 16),
                    const Text(
                      'Market',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Travel to a new location (−1 day)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: gameState.allLocations.map((location) {
                        final isSelected =
                            location.id == gameState.currentLocation.id;
                        final hasDaysLeft = gameState.daysLeft > 0;
                        return OutlinedButton(
                          style: outlinedIntentStyle(_locationAccentColor),
                          onPressed: isSelected || !hasDaysLeft
                              ? null
                              : () async {
                                  final moved = await gameActions.setLocation(
                                    location.id,
                                  );
                                  if (!moved || !context.mounted) return;

                                  final event = gameState.marketEvent;
                                  if (event != null) {
                                    await _showMarketEventDialog(
                                      context,
                                      gameState,
                                      event,
                                    );
                                  }

                                  if (context.mounted && gameState.isGameOver) {
                                    Navigator.pushNamed(context, '/game_over');
                                  }
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
                        final event = gameState.marketEvent;
                        final isAffected = event?.sweetId == sweet.id;
                        final canBuy = gameState.player.cash >= buyPrice;
                        final canSell = ownedQuantity > 0;
                        final maxBuyQuantity = buyPrice > 0
                            ? (gameState.player.cash / buyPrice).floor()
                            : 0;
                        final canBuyMax = maxBuyQuantity > 0;

                        final cardColor = _sweetCardColors[sweet.id];

                        return Card(
                          color: cardColor ??
                              Theme.of(context).colorScheme.surface,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        sweet.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (isAffected && event != null)
                                      _MarketEventBadge(event: event),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Buy: \$${buyPrice.toStringAsFixed(2)}  •  Sell: \$${sellPrice.toStringAsFixed(2)}',
                                ),
                                Text('You own: $ownedQuantity'),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ElevatedButton(
                                          style: buyButtonStyle,
                                          onPressed: canBuy
                                              ? () {
                                                  gameActions.buy(sweet.id, 1);
                                                }
                                              : null,
                                          child: const Text('Buy 1'),
                                        ),
                                        ElevatedButton(
                                          style: buyButtonStyle,
                                          onPressed: canBuyMax
                                              ? () {
                                                  gameActions.buy(
                                                    sweet.id,
                                                    maxBuyQuantity,
                                                  );
                                                }
                                              : null,
                                          child: const Text('Buy Max'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        OutlinedButton(
                                          style:
                                              outlinedIntentStyle(_sellAccentColor),
                                          onPressed: canSell
                                              ? () {
                                                  gameActions.sell(
                                                    sweet.id,
                                                    1,
                                                  );
                                                }
                                              : null,
                                          child: const Text('Sell 1'),
                                        ),
                                        OutlinedButton(
                                          style:
                                              outlinedIntentStyle(_sellAccentColor),
                                          onPressed: canSell
                                              ? () {
                                                  gameActions.sell(
                                                    sweet.id,
                                                    ownedQuantity,
                                                  );
                                                }
                                              : null,
                                          child: const Text('Sell All'),
                                        ),
                                      ],
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
                        children:
                            gameState.player.inventory.entries.map((entry) {
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
                        }).toList(),
                      ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: gameState.isGameOver
                          ? null
                          : () async {
                              await gameState.markGameOver();
                              if (context.mounted) {
                                Navigator.pushNamed(context, '/game_over');
                              }
                            },
                      child: const Text('Give up'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
