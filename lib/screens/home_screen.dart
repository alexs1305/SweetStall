import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import '../services/leaderboard_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final leaderboardService = context.read<LeaderboardService>();
    final leaderboard = leaderboardService.loadTopScores();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SweetStall'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sweet Trading Academy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Cash on hand: \$${gameState.player.cash.toStringAsFixed(2)}'),
            Text('Current location: ${gameState.currentLocation.name}'),
            Text('Days remaining: ${gameState.daysLeft}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                gameState.resetGame();
                Navigator.pushNamed(context, '/play');
              },
              child: const Text('Start trading'),
            ),
            const SizedBox(height: 24),
            const Text(
              'High Scores',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: leaderboard.isEmpty
                  ? const Center(
                      child: Text(
                        'No scores yet. Play a round to create a high score!',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: leaderboard.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final entry = leaderboard[index];
                        return ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(
                            entry.name ?? 'Guest Trader',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Text(
                            '\$${entry.score.toStringAsFixed(2)}',
                          ),
                          subtitle: entry.date != null
                              ? Text(
                                  'Set on ${entry.date!.toLocal().toString().split('.').first}',
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
