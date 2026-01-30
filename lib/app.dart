import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game/game_actions.dart';
import 'game/game_state.dart';
import 'screens/game_over_screen.dart';
import 'screens/home_screen.dart';
import 'screens/play_screen.dart';
import 'services/leaderboard_service.dart';

class SweetStallApp extends StatelessWidget {
  final LeaderboardService leaderboardService;

  const SweetStallApp({
    required this.leaderboardService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LeaderboardService>.value(value: leaderboardService),
        ChangeNotifierProvider<GameState>(
          create: (_) => GameState.withDefaults(leaderboardService),
        ),
        ProxyProvider<GameState, GameActions>(
          update: (_, gameState, __) => GameActions(gameState),
        ),
      ],
      child: MaterialApp(
        title: 'SweetStall',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/play': (_) => const PlayScreen(),
          '/game_over': (_) => const GameOverScreen(),
        },
      ),
    );
  }
}
