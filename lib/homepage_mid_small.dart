import 'package:flutter/material.dart';
import 'providers/navigation_provider.dart';
import 'rooms.dart';
import 'utils.dart';
import 'package:provider/provider.dart';

class HomePageMediumOrSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    return Scaffold(
      floatingActionButton: navigationState.selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          themeToggleButton(),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // back to login screen
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Builder(builder: (context) {
          switch (navigationState.selectedIndex) {
            case 0:
              return Text('Unknown');
            case 1:
              return RoomsPage();
            case 2:
              return Text('Unknown');
            default:
              return Text('Unknown');
          }
        }),
      ),
      bottomNavigationBar: NavigationBar(
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
      ),
    );
  }
}
