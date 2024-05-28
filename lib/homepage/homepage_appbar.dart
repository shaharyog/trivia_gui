import 'package:flutter/material.dart';
import '../screens/auth/login.dart';
import '../src/rust/api/session.dart';
import '../utils/common_widgets/toggle_theme_button.dart';

AppBar getHomePageAppbar({
  required final int navigationIndex,
  required final Session session,
  required BuildContext context,
}) {
  return AppBar(
    title: Builder(
      builder: (context) {
        switch (navigationIndex) {
          case 0:
            return const Text('Leaderboard');
          case 1:
            return const Text('Rooms');
          case 2:
            return const Text('Profile');
          default:
            return const Text('Unknown');
        }
      },
    ),
    actions: getActions(context, session),
  );
}

List<Widget> getActions(BuildContext context, final Session session) {
  return [
    Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: themeToggleButton(context),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          // logout when entering the login page, otherwise,
          // widgets in the homepage might access the session after logout
          // the logout will execute immediately when initializing the login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                errorDialogData: null,
                previousSession: session,
              ),
            ),
          );
        },
      ),
    ),
  ];
}
