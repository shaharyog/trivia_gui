import 'package:flutter/material.dart';
import '../providers/navigation_provider.dart';
import '../utils.dart';
import 'toggle_theme_button.dart';

AppBar HomePageAppBar({
  required NavigationState navigationState,
  required BuildContext context,
}) {
  return AppBar(
    title: Builder(
      builder: (context) {
        switch (navigationState.selectedIndex) {
          case 0:
            return Text('Profile');
          case 1:
            return Text('Rooms');
          case 2:
            return Text('Leaderboard');
          default:
            return Text('Unknown');
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
          icon: Icon(Icons.logout),
          onPressed: () {
            // back to login screen
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ),
    ],
  );
}
