import 'package:flutter/material.dart';

import '../models/leaderboard_entry.dart';

class HighScoreList extends StatelessWidget {
  const HighScoreList({
    super.key,
    required this.entries,
    this.title,
    this.emptyMessage = 'No scores yet.',
  });

  final List<LeaderboardEntry> entries;
  final String? title;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Text(
                    emptyMessage ?? 'No scores yet.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return ListTile(
                      leading: Text('${index + 1}'),
                      title: Text('\$${entry.score.toStringAsFixed(2)}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
