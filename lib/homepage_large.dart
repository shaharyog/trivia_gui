import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_flutter_app_name/rooms.dart';
import 'providers/navigation_provider.dart';
import 'utils.dart';

class HomePageLarge extends StatelessWidget {
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
      drawer: NavigationDrawer(
        selectedIndex: navigationState.selectedIndex,
        onDestinationSelected: (int index) {
          navigationState.selectedIndex = index;
        },
        children: const <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
        ],
      ),
      appBar: AppBar(
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
    );
  }
}
