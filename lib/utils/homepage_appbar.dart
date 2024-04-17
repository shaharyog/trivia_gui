import 'package:flutter/material.dart';
import '../providers/navigation_provider.dart';
import 'toggle_theme_button.dart';

AppBar homePageAppBar({
  required NavigationState navigationState,
  required BuildContext context,
}) {
  return AppBar(
    title: Builder(
      builder: (context) {
        switch (navigationState.selectedIndex) {
          case 0:
            return const Text('Profile');
          case 1:
            return const Text('Rooms');
          case 2:
            return const Text('Leaderboard');
          default:
            return const Text('Unknown');
        }
      },
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: themeToggleButton(),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // back to login screen
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ),
    ],
  );
}
