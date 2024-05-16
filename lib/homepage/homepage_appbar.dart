import 'package:flutter/material.dart';
import 'package:trivia/utils/common_functionalities/reset_providers.dart';
import '../src/rust/api/error.dart';
import '../src/rust/api/session.dart';
import '../utils/dialogs/error_dialog.dart';
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
      child: themeToggleButton(),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          try {
            await session.logout();
          } on Error_LogoutError catch (e) {
            if (context.mounted) {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    title: "Logout Error",
                    message: "${e.format()}, Returning to login page...",
                  );
                },
              );
            }
          } on Error_ServerConnectionError catch (e) {
            if (context.mounted) {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    title: "Server Connection Error",
                    message: "${e.format()}, Returning to login page...",
                  );
                },
              );
            }
          } on Error catch (e) {
            if (context.mounted) {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    title: "Error",
                    message: "${e.format()}, Returning to login page...",
                  );
                },
              );
            }
          } finally {
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
              resetProviders(context);
            }
          }
        },
      ),
    ),
  ];
}
