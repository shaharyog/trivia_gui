import 'package:flutter/material.dart';
import '../providers/navigation_provider.dart';
import '../utils.dart';
import 'package:provider/provider.dart';
import '../utils/floating_action_button.dart';
import '../utils/homepage_appbar.dart';
import '../utils/homepage_body.dart';
import '../utils/nav/small_medium_nav_bar.dart';

class HomePageSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    return Scaffold(
      appBar: HomePageAppBar(
        navigationState: navigationState,
        context: context,
      ),
      bottomNavigationBar: HomePageSmallOrMediumNavBar(
        navigationState: navigationState,
        context: context,
      ),
      body: HomePageBody(
        navigationState: navigationState,
        screenSize: ScreenSize.small,
        context: context,
      ),
      floatingActionButton: HomePageFloatingActionButton(
        navigationState: navigationState,
        context: context,
      ),
    );
  }
}
