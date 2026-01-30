import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import '../services/leaderboard_service.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final leaderboardService = context.read<LeaderboardService>();
    final leaderboard = leaderboardService.loadTopScores();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time has run out!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Final cash: \$${gameState.finalScore.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Leaderboard',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: leaderboard.isEmpty
                  ? const Center(
                      child: Text('No leaderboard entries yet.'),
                    )
                  : ListView.separated(
                      itemCount: leaderboard.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final entry = leaderboard[index];
                        return ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(entry.name ?? 'Guest Trader'),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                gameState.resetGame();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
