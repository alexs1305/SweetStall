import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/models/leaderboard_entry.dart';

void main() {
  group('LeaderboardEntry', () {
    test('toJson and fromJson round-trip with all fields', () {
      final date = DateTime(2025, 1, 15, 12, 30);
      final entry = LeaderboardEntry(score: 100, name: 'A', date: date);
      final jsonFull = entry.toJson();
      expect(jsonFull['score'], 100);
      expect(jsonFull['name'], 'A');
      expect(jsonFull['date'], date.toIso8601String());

      final decoded = LeaderboardEntry.fromJson(jsonFull);
      expect(decoded.score, entry.score);
      expect(decoded.name, entry.name);
      expect(decoded.date?.millisecondsSinceEpoch, entry.date?.millisecondsSinceEpoch);
    });

    test('fromJson handles missing optional fields', () {
      final json = {'score': 50};
      final entry = LeaderboardEntry.fromJson(json);
      expect(entry.score, 50);
      expect(entry.name, isNull);
      expect(entry.date, isNull);
    });

    test('toJson omits null optional fields', () {
      const entry = LeaderboardEntry(score: 75);
      final json = entry.toJson();
      expect(json.containsKey('score'), isTrue);
      expect(json.containsKey('name'), isFalse);
      expect(json.containsKey('date'), isFalse);
    });

    test('toString includes score', () {
      const entry = LeaderboardEntry(score: 100, name: 'X');
      expect(entry.toString(), contains('100'));
    });
  });
}
