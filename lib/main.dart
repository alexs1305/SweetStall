import 'package:flutter/material.dart';

import 'app.dart';
import 'services/leaderboard_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final leaderboardService = await LeaderboardService.initialize();
  runApp(SweetStallApp(leaderboardService: leaderboardService));
}
