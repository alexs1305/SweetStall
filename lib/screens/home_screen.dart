import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import '../services/leaderboard_service.dart';
import '../widgets/high_score_list.dart';

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
              'Can you make a profit?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                gameState.resetGame();
                Navigator.pushNamed(context, '/play');
              },
              child: const Text('Start playing'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: HighScoreList(
                entries: leaderboard,
                title: 'High Scores',
                emptyMessage:
                    'No scores yet. Play a round to create a high score!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
