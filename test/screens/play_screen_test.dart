import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetstall/data/game_data.dart';
import 'package:sweetstall/game/game_actions.dart';
import 'package:sweetstall/game/game_state.dart';
import 'package:sweetstall/models/market_event.dart';
import 'package:sweetstall/screens/play_screen.dart';
import 'package:sweetstall/services/leaderboard_service.dart';

class FakeGameActions extends GameActions {
  FakeGameActions(GameState gameState, this.event) : super(gameState);

  final MarketEvent event;

  @override
  Future<bool> setLocation(String locationId) async {
    gameState.updatePlayer(
      gameState.player.copyWith(currentLocationId: locationId),
    );
    gameState.updateMarketWithEvent(
      gameState.market.applyEvent(event),
      event,
    );
    await advanceTime();
    return true;
  }
}

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

  Widget buildTestWidget({GameActions? actions}) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          Provider<LeaderboardService>.value(value: leaderboardService),
          ChangeNotifierProvider<GameState>.value(value: gameState),
          Provider<GameActions>.value(
            value: actions ?? GameActions(gameState),
          ),
        ],
        child: const PlayScreen(),
      ),
    );
  }

  testWidgets('PlayScreen shows location, days, cash, Market, travel hint, Give up', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Travel to a new location (−1 day)'), findsOneWidget);
    expect(find.text('Give up'), findsOneWidget);
    expect(find.textContaining('Current location'), findsOneWidget);
    expect(find.textContaining('Days left'), findsOneWidget);
  });

  testWidgets('PlayScreen shows sweets from GameData with buy and sell actions',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    for (final sweet in GameData.sweets) {
      expect(find.text(sweet.name), findsOneWidget);
    }
    expect(find.text('Buy 1'), findsNWidgets(GameData.sweets.length));
    expect(find.text('Buy Max'), findsNWidgets(GameData.sweets.length));
    expect(find.text('Sell 1'), findsNWidgets(GameData.sweets.length));
    expect(find.text('Sell All'), findsNWidgets(GameData.sweets.length));
  });

  testWidgets('PlayScreen shows event badge for affected sweet',
      (WidgetTester tester) async {
    final event = MarketEvent(
      id: 1,
      sweetId: GameData.sweets.first.id,
      type: MarketEventType.crash,
      priceMultiplier: 0.6,
      occurredAt: DateTime(2024),
    );
    gameState.updateMarketWithEvent(
      gameState.market.applyEvent(event),
      event,
    );

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Crash'), findsOneWidget);
  });

  testWidgets('PlayScreen shows event dialog after travel',
      (WidgetTester tester) async {
    final event = MarketEvent(
      id: 2,
      sweetId: GameData.sweets.first.id,
      type: MarketEventType.shortage,
      priceMultiplier: 1.5,
      occurredAt: DateTime(2024),
    );
    final actions = FakeGameActions(gameState, event);

    await tester.pumpWidget(buildTestWidget(actions: actions));

    final otherLocation = GameData.locations.firstWhere(
      (location) => location.id != gameState.currentLocation.id,
    );
    await tester.tap(find.text(otherLocation.name));
    await tester.pumpAndSettle();

    expect(find.text('Demand surge!'), findsOneWidget);
    expect(find.textContaining('prices are 50% higher'), findsOneWidget);
  });
}
