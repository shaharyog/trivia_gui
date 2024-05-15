import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../utils/floating_action_button.dart';
import '../utils/homepage_appbar.dart';
import '../utils/homepage_body.dart';
import '../utils/nav/large_nav_drawer.dart';

class HomePageLarge extends StatefulWidget {

  const HomePageLarge({super.key});

  @override
  State<HomePageLarge> createState() => _HomePageLargeState();
}

class _HomePageLargeState extends State<HomePageLarge> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: homePageAppBar(
        navigationState: navigationState,
        context: context,
      ),
      drawer: homePageLargeNavDrawer(
        navigationState: navigationState,
        scaffoldKey: _scaffoldKey,
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
