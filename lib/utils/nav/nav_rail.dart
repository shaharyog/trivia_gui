import 'package:flutter/material.dart';
import '../../homepage/homepage_appbar.dart';
import '../../src/rust/api/session.dart';

class HomePageNavRail extends StatelessWidget {
  final int navigationIndex;
  final ValueChanged<int> onDestinationSelected;
  final Session session;

  const HomePageNavRail({
    super.key,
    required this.navigationIndex,
    required this.onDestinationSelected,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: navigationIndex,
      onDestinationSelected: onDestinationSelected,
      leading: Column(
        children: getActions(context, session).reversed.toList(),
      ),
      groupAlignment: 0,
      // Center the items
      labelType: NavigationRailLabelType.selected,
      destinations: const [
        NavigationRailDestination(
          selectedIcon: Icon(Icons.leaderboard),
          icon: Icon(Icons.leaderboard_outlined),
          label: Text('Leaderboard'),
        ),
        NavigationRailDestination(
          selectedIcon: Icon(Icons.holiday_village),
          icon: Icon(Icons.holiday_village_outlined),
          label: Text('Rooms'),
        ),
        NavigationRailDestination(
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
