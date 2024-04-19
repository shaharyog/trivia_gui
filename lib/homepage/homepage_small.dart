import 'package:flutter/material.dart';
import '../providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import '../utils/floating_action_button.dart';
import '../utils/homepage_appbar.dart';
import '../utils/homepage_body.dart';
import '../utils/nav/small_medium_nav_bar.dart';

class HomePageSmall extends StatelessWidget {
  const HomePageSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    return Scaffold(
      appBar: homePageAppBar(
        navigationState: navigationState,
        context: context,
      ),
      bottomNavigationBar: homePageSmallOrMediumNavBar(
        navigationState: navigationState,
        context: context,
      ),
      body: homePageBody(
        navigationState: navigationState,
        context: context,
      ),
      floatingActionButton: homePageFloatingActionButton(
        navigationState: navigationState,
        context: context,
      ),
    );
  }
}
