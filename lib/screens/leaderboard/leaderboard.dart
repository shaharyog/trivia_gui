
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/leaderboard_provider.dart';
import '../../providers/screen_size_provider.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {

    final screenSizeProvider = Provider.of<ScreenSizeProvider>(context);
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);

    return Column(
      children: [

      ],
    );
  }
}
