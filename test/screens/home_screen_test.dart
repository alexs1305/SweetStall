import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetstall/game/game_actions.dart';
import 'package:sweetstall/game/game_state.dart';
import 'package:sweetstall/screens/home_screen.dart';
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
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('HomeScreen shows cash, location, days, and Start trading', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('SweetStall'), findsOneWidget);
    expect(find.text('Sweet Trading Academy'), findsOneWidget);
    expect(find.text('Start trading'), findsOneWidget);
    expect(find.textContaining('Cash on hand'), findsOneWidget);
    expect(find.textContaining('Days remaining'), findsOneWidget);
  });

  testWidgets('HomeScreen shows empty leaderboard message when no scores', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(
      find.text('No scores yet. Play a round to create a high score!'),
      findsOneWidget,
    );
  });
}
