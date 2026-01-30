import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetstall/app.dart';
import 'package:sweetstall/services/leaderboard_service.dart';

void main() {
  late LeaderboardService leaderboardService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    leaderboardService = LeaderboardService(prefs);
  });

  testWidgets('App shows home and SweetStall title', (WidgetTester tester) async {
    await tester.pumpWidget(SweetStallApp(leaderboardService: leaderboardService));

    expect(find.text('SweetStall'), findsOneWidget);
    expect(find.text('Sweet Trading Academy'), findsOneWidget);
    expect(find.text('Start trading'), findsOneWidget);
  });

  testWidgets('Start trading navigates to play screen', (WidgetTester tester) async {
    await tester.pumpWidget(SweetStallApp(leaderboardService: leaderboardService));

    await tester.tap(find.text('Start trading'));
    await tester.pumpAndSettle();

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('End day'), findsOneWidget);
    expect(find.text('Return home'), findsOneWidget);
  });
}
