import 'package:flutter/material.dart';
import '../providers/navigation_provider.dart';

FloatingActionButton? HomePageFloatingActionButton(
    {required NavigationState navigationState, required BuildContext context}) {
  return navigationState.selectedIndex == 1
      ? FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        )
      : null;
}
