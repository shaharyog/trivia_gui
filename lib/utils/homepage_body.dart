import 'package:flutter/material.dart';
import '../providers/navigation_provider.dart';
import '../screens/leaderboard/leaderboard.dart';
import '../screens/rooms/rooms.dart';

Widget homePageBody({
  required NavigationState navigationState,
  required BuildContext context,
}) {
  return Builder(builder: (context) {
    switch (navigationState.selectedIndex) {
      case 0:
        return const Text('Unknown');
      case 1:
        return const RoomsWidget();
      case 2:
        return const Leaderboard();
      default:
        return const Text('Unknown');
    }
  });
}
