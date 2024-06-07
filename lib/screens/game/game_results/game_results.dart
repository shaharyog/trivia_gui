import 'package:flutter/material.dart';

import '../../../consts.dart';
import '../../../homepage/homepage.dart';
import '../../../src/rust/api/error.dart';
import '../../../src/rust/api/session.dart';
import '../../../utils/common_widgets/toggle_theme_button.dart';
import '../../../utils/dialogs/error_dialog.dart';
import '../../auth/login.dart';
import '../game.dart';

class GameResultsPage extends StatefulWidget {
  final Session session;
  final String username;
  const GameResultsPage({super.key, required this.session, required this.username});

  @override
  State<GameResultsPage> createState() => _GameResultsPageState();
}

class _GameResultsPageState extends State<GameResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: themeToggleButton(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app_sharp),
              onPressed: () {
                leaveGame(context);
              },
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Game Finish'),
      ),
    );
  }

  void leaveGame(context) async {
    final isConfirmed = await launchExitConfirmationDialog(context, "Leave Game Results", "Are you sure you want to navigate back to menu?");
    if (!isConfirmed) return;

    try {
      await widget.session.leaveGame();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            session: widget.session,
            username: widget.username,
          ),
        ),
      );
    } on Error_ServerConnectionError {
      // TODO dispose
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            errorDialogData: ErrorDialogData(
              title: serverConnErrorText,
              message: serverConnErrorText,
            ),
          ),
        ),
      );
    } on Error catch (error) {
      showErrorDialog(context, "Failed to leave game", error.format());
    }
  }
}
