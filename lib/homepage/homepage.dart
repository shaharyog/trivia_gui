import 'package:flutter/material.dart';
import '../utils/filters.dart';
import '../src/rust/api/session.dart';
import '../utils/common_functionalities/screen_size.dart';
import '../utils/common_widgets/floating_action_button.dart';
import 'homepage_appbar.dart';
import 'homepage_body.dart';
import '../utils/nav/nav_rail.dart';
import '../utils/nav/nav_bar.dart';

class HomePage extends StatefulWidget {
  final Session session;
  final String username;

  const HomePage({
    super.key,
    required this.session,
    required this.username,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;
  Filters filters = Filters();
  bool isInCreateRoomSheet = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: screenSize == ScreenSize.small
            ? getHomePageAppbar(
                navigationIndex: _currentNavIndex,
                session: widget.session,
                context: context,
              )
            : null,
        bottomNavigationBar: screenSize == ScreenSize.small
            ? HomePageBottomNavBar(
                navigationIndex: _currentNavIndex,
                onDestinationSelected: destinationSelected,
              )
            : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (screenSize != ScreenSize.small)
              HomePageNavRail(
                navigationIndex: _currentNavIndex,
                onDestinationSelected: destinationSelected,
                session: widget.session,
              ),
            if (screenSize != ScreenSize.small)
              const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: HomePageBody(
                username: widget.username,
                navigationIndex: _currentNavIndex,
                session: widget.session,
                filters: filters,
                isInCreateRoomSheet: isInCreateRoomSheet,
              ),
            ),
          ],
        ),
        floatingActionButton: _currentNavIndex == 1
            ? HomePageFloatingActionButton(
                username: widget.username,
                inCreateRoomSheetChanged: (value) {
                  setState(() {
                    isInCreateRoomSheet = value;
                  });
                },
                navigationIndex: _currentNavIndex,
                session: widget.session,
              )
            : null,
      ),
    );
  }

  void destinationSelected(int index) {
    if (_currentNavIndex == index) {
      return;
    }
    setState(() {
      _currentNavIndex = index;
    });
  }
}
