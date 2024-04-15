import 'package:flutter/material.dart';
import '../providers/navigation_provider.dart';
import '../screens/rooms.dart';
import '../utils.dart';

Widget HomePageBody({
  required NavigationState navigationState,
  required ScreenSize screenSize,
  required BuildContext context,
}) {
  return Center(
    child: Builder(builder: (context) {
      switch (navigationState.selectedIndex) {
        case 0:
          return Text('Unknown');
        case 1:
          return RoomsWidget(screenSize: screenSize);
        case 2:
          return Text('Unknown');
        default:
          return Text('Unknown');
      }
    }),
  );
}
