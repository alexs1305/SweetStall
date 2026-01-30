import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetstall/models/leaderboard_entry.dart';
import 'package:sweetstall/services/leaderboard_service.dart';

void main() {
  late LeaderboardService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    service = LeaderboardService(prefs, maxEntries: 3);
  });

  group('LeaderboardService', () {
    test('loadTopScores returns empty when no data', () {
      expect(service.loadTopScores(), isEmpty);
    });

    test('addScore persists and returns sorted list by score descending', () async {
      final result = await service.addScore(
        const LeaderboardEntry(score: 50),
      );
      expect(result.length, 1);
      expect(result.first.score, 50);

      await service.addScore(const LeaderboardEntry(score: 100));
      final top = service.loadTopScores();
      expect(top.length, 2);
      expect(top.first.score, 100);
      expect(top[1].score, 50);
    });

    test('addScore respects maxEntries', () async {
      await service.addScore(const LeaderboardEntry(score: 10));
      await service.addScore(const LeaderboardEntry(score: 20));
      await service.addScore(const LeaderboardEntry(score: 30));
      final afterThree = service.loadTopScores();
      expect(afterThree.length, 3);

      await service.addScore(const LeaderboardEntry(score: 5));
      final afterFour = service.loadTopScores();
      expect(afterFour.length, 3);
      expect(afterFour.map((e) => e.score).toList(), [30, 20, 10]);
    });

    test('loadTopScores returns unmodifiable list', () {
      expect(() => service.loadTopScores().add(
            const LeaderboardEntry(score: 0),
          ), throwsUnsupportedError);
    });
  });
}
