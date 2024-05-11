import 'package:flutter/material.dart';

import '../../providers/navigation_provider.dart';

Widget homePageLargeNavDrawer({
  required NavigationState navigationState,
  required BuildContext context,
}) {
  return NavigationDrawer(
    selectedIndex: navigationState.selectedIndex,
    onDestinationSelected: (int index) {
      navigationState.selectedIndex = index;
      Navigator.of(context).pop();
    },
    children: const <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
      ),
      NavigationDrawerDestination(
        selectedIcon: Icon(Icons.person),
        icon: Icon(Icons.person_outline),
        label: Text('Profile'),
      ),
      SizedBox(height: 8),
      NavigationDrawerDestination(
        selectedIcon: Icon(Icons.holiday_village),
        icon: Icon(Icons.holiday_village_outlined),
        label: Text('Rooms'),
      ),
      SizedBox(height: 8),
      NavigationDrawerDestination(
        selectedIcon: Icon(Icons.leaderboard),
        icon: Icon(Icons.leaderboard_outlined),
        label: Text('Leaderboard'),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
        child: Divider(),
      ),
    ],
  );
}
