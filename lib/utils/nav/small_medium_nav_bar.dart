import 'package:flutter/material.dart';
import '../../providers/navigation_provider.dart';

NavigationBar HomePageSmallOrMediumNavBar(
    {required NavigationState navigationState, required BuildContext context}) {
  return NavigationBar(
    onDestinationSelected: (int index) {
      navigationState.selectedIndex = index;
    },
    selectedIndex: navigationState.selectedIndex,
    destinations: const <NavigationDestination>[
      NavigationDestination(
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
          label: 'Profile',
          tooltip: ''),
      NavigationDestination(
          selectedIcon: Icon(Icons.holiday_village),
          icon: Icon(Icons.holiday_village_outlined),
          label: 'Rooms',
          tooltip: ''),
      NavigationDestination(
          selectedIcon: Icon(Icons.leaderboard),
          icon: Icon(Icons.leaderboard_outlined),
          label: 'Leaderboard',
          tooltip: '')
    ],
  );
}
