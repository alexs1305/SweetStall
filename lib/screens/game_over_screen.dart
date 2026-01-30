import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import '../services/leaderboard_service.dart';
import '../widgets/high_score_list.dart';

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
            Expanded(
              child: HighScoreList(
                entries: leaderboard,
                title: 'Leaderboard',
                emptyMessage: 'No leaderboard entries yet.',
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
