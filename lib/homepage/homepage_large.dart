import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_flutter_app_name/utils/homepage_body.dart';
import 'package:your_flutter_app_name/utils/nav/large_nav_drawer.dart';
import '../providers/navigation_provider.dart';
import '../utils.dart';
import '../utils/floating_action_button.dart';
import '../utils/homepage_appbar.dart';

class HomePageLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    return Scaffold(
      appBar: HomePageAppBar(
        navigationState: navigationState,
        context: context,
      ),
      drawer: HomePageLargeNavDrawer(
        navigationState: navigationState,
        context: context,
      ),
      body: HomePageBody(
        navigationState: navigationState,
        screenSize: ScreenSize.large,
        context: context,
      ),
      floatingActionButton: HomePageFloatingActionButton(
        navigationState: navigationState,
        context: context,
      ),
    );
  }
}
