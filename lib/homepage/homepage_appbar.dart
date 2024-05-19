import 'package:flutter/material.dart';
import '../consts.dart';
import '../screens/auth/login.dart';
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
      child: themeToggleButton(context),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          ErrorDialogData? errorDialogData;
          try {
            await session.logout();
          } on Error_LogoutError catch (e) {
            errorDialogData = ErrorDialogData(
              title: logoutErrorText,
              message: e.format(),
            );
          } on Error_ServerConnectionError catch (e) {
            errorDialogData = ErrorDialogData(
              title: serverConnErrorText,
              message: e.format(),
            );
          } on Error catch (e) {
            errorDialogData = ErrorDialogData(
              title: unknownErrorText,
              message: e.format(),
            );
          } finally {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    errorDialogData: errorDialogData,
                  ),
                ),
              );
            }
          }
        },
      ),
    ),
  ];
}
