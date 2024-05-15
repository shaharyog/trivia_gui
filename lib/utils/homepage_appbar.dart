import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/providers/session_provider.dart';
import '../providers/navigation_provider.dart';
import '../src/rust/api/error.dart';
import 'error_dialog.dart';
import 'toggle_theme_button.dart';

AppBar homePageAppBar({
  required NavigationState navigationState,
  required BuildContext context,
}) {
  return AppBar(
    title: Builder(
      builder: (context) {
        switch (navigationState.selectedIndex) {
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
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: themeToggleButton(),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            Navigator.of(context).pushReplacementNamed('/login');
            final sessionProvider =
                Provider.of<SessionProvider>(context, listen: false);
            try {
              sessionProvider.session!.logout();
            } on Error_LogoutError catch (e) {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      title: "Logout Error",
                      message: e.format(),
                    );
                  });
            } on Error_ServerConnectionError catch (e) {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      title: "Server Connection Error",
                      message: e.format(),
                    );
                  });
            } on Error catch (e) {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      title: "Error",
                      message: e.format(),
                    );
                  });
            } finally {
              sessionProvider.session = null;
            }
          },
        ),
      ),
    ],
  );
}
