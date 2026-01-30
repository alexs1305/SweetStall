import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/leaderboard_entry.dart';

class LeaderboardService {
  static const _leaderboardKey = 'leaderboard_entries';

  final SharedPreferences _preferences;
  final int maxEntries;

  LeaderboardService(this._preferences, {this.maxEntries = 10})
      : assert(maxEntries > 0, 'maxEntries must be positive');

  static Future<LeaderboardService> initialize({int maxEntries = 10}) async {
    final preferences = await SharedPreferences.getInstance();
    return LeaderboardService(preferences, maxEntries: maxEntries);
  }

  List<LeaderboardEntry> _readEntries() {
    final rawEntries = _preferences.getStringList(_leaderboardKey);
    if (rawEntries == null) return [];
    final decodedEntries = <LeaderboardEntry>[];
    for (final raw in rawEntries) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          decodedEntries.add(LeaderboardEntry.fromJson(decoded));
        }
      } catch (_) {
        // Skip corrupted entries.
      }
    }
    return _sortEntries(decodedEntries);
  }

  Future<void> _saveEntries(List<LeaderboardEntry> entries) {
    final encoded =
        entries.map((entry) => jsonEncode(entry.toJson())).toList();
    return _preferences.setStringList(_leaderboardKey, encoded);
  }

  List<LeaderboardEntry> _sortEntries(List<LeaderboardEntry> entries) {
    entries.sort((a, b) => b.score.compareTo(a.score));
    if (entries.length > maxEntries) {
      return entries.sublist(0, maxEntries);
    }
    return entries;
  }

  List<LeaderboardEntry> loadTopScores() => List.unmodifiable(_readEntries());

  Future<List<LeaderboardEntry>> addScore(LeaderboardEntry entry) async {
    final updated = _updateEntries(entry);
    await _saveEntries(updated);
    return updated;
  }

  List<LeaderboardEntry> _updateEntries(LeaderboardEntry newEntry) {
    final currentEntries = List<LeaderboardEntry>.from(_readEntries());
    currentEntries.add(newEntry);
    return _sortEntries(currentEntries);
  }
}
