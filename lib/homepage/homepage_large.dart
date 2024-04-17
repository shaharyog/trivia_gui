import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../utils/floating_action_button.dart';
import '../utils/homepage_appbar.dart';
import '../utils/homepage_body.dart';
import '../utils/nav/large_nav_drawer.dart';

class HomePageLarge extends StatelessWidget {
  const HomePageLarge({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    return Scaffold(
      appBar: homePageAppBar(
        navigationState: navigationState,
        context: context,
      ),
      drawer: homePageLargeNavDrawer(
        navigationState: navigationState,
        context: context,
      ),
      body: homePageBody(
        navigationState: navigationState,
        context: context,
      ),
      floatingActionButton: HomePageFloatingActionButton(
        navigationState: navigationState,
        context: context,
      ),
    );
  }
}
