import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetstall/game/game_actions.dart';
import 'package:sweetstall/game/game_state.dart';
import 'package:sweetstall/screens/game_over_screen.dart';
import 'package:sweetstall/services/leaderboard_service.dart';

void main() {
  late LeaderboardService leaderboardService;
  late GameState gameState;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    leaderboardService = LeaderboardService(prefs);
  });

  setUp(() async {
    gameState = GameState.withDefaults(leaderboardService);
    gameState.updateDaysLeft(0);
    await gameState.markGameOver();
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
        child: const GameOverScreen(),
      ),
    );
  }

  testWidgets('GameOverScreen shows Game Over, final cash, Back to home', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Game Over'), findsOneWidget);
    expect(find.text('Time has run out!'), findsOneWidget);
    expect(find.textContaining('Final cash'), findsOneWidget);
    expect(find.text('Back to home'), findsOneWidget);
  });

  testWidgets('GameOverScreen shows Leaderboard section', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Leaderboard'), findsOneWidget);
  });
}
