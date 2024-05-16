import 'package:flutter/material.dart';

class HomePageBottomNavBar extends StatelessWidget {
  final int navigationIndex;
  final ValueChanged<int> onDestinationSelected;

  const HomePageBottomNavBar({
    super.key,
    required this.navigationIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: navigationIndex,
      destinations: const <NavigationDestination>[
        NavigationDestination(
            selectedIcon: Icon(Icons.leaderboard),
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Leaderboard',
            tooltip: ''),
        NavigationDestination(
            selectedIcon: Icon(Icons.holiday_village),
            icon: Icon(Icons.holiday_village_outlined),
            label: 'Rooms',
            tooltip: ''),
        NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            tooltip: ''),
      ],
    );
  }
}
