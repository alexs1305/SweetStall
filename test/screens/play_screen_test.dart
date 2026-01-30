import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetstall/data/game_data.dart';
import 'package:sweetstall/game/game_actions.dart';
import 'package:sweetstall/game/game_state.dart';
import 'package:sweetstall/screens/play_screen.dart';
import 'package:sweetstall/services/leaderboard_service.dart';

void main() {
  late LeaderboardService leaderboardService;
  late GameState gameState;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    leaderboardService = LeaderboardService(prefs);
  });

  setUp(() {
    gameState = GameState.withDefaults(leaderboardService);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          Provider<LeaderboardService>.value(value: leaderboardService),
          ChangeNotifierProvider<GameState>.value(value: gameState),
          ProxyProvider<GameState, GameActions>(
            update: (_, state, __) => GameActions(state),
          ),
        ],
        child: const PlayScreen(),
      ),
    );
  }

  testWidgets('PlayScreen shows location, days, cash, Market, travel hint, Return home', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Travel to a new location (−1 day)'), findsOneWidget);
    expect(find.text('Return home'), findsOneWidget);
    expect(find.textContaining('Current location'), findsOneWidget);
    expect(find.textContaining('Days left'), findsOneWidget);
  });

  testWidgets('PlayScreen shows sweets from GameData with Buy 1 and Sell 1', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    for (final sweet in GameData.sweets) {
      expect(find.text(sweet.name), findsOneWidget);
    }
    expect(find.text('Buy 1'), findsNWidgets(GameData.sweets.length));
    expect(find.text('Sell 1'), findsNWidgets(GameData.sweets.length));
  });
}
