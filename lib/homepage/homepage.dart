import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/providers/screen_size_provider.dart';
import '../providers/navigation_provider.dart';
import '../utils/floating_action_button.dart';
import '../utils/homepage_appbar.dart';
import '../utils/homepage_body.dart';
import '../utils/nav/large_nav_drawer.dart';
import '../utils/nav/small_medium_nav_bar.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      drawer: Provider.of<ScreenSizeProvider>(context).screenSize != ScreenSize.small ? homePageLargeNavDrawer(
        navigationState: navigationState,
        scaffoldKey: _scaffoldKey,
      ) : null,
      bottomNavigationBar: Provider.of<ScreenSizeProvider>(context).screenSize == ScreenSize.small ? homePageSmallOrMediumNavBar(
        navigationState: navigationState,
        context: context,
      ) : null,
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
