import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/homepage/homepage.dart';
import 'package:trivia/src/rust/api/request/get_game_results.dart';
import 'package:trivia/utils/common_widgets/toggle_theme_button.dart';
import '../../../consts.dart';
import '../../../src/rust/api/error.dart';
import '../../../src/rust/api/session.dart';
import '../../../utils/dialogs/error_dialog.dart';
import '../../auth/login.dart';
import 'game_overview.dart';
import 'game_results_content.dart';

class GameResultsPage extends StatefulWidget {
  final Session session;
  final String username;
  final String gameName;

  const GameResultsPage({
    super.key,
    required this.session,
    required this.username,
    required this.gameName,
  });

  @override
  State<GameResultsPage> createState() => _GameResultsPageState();
}

class _GameResultsPageState extends State<GameResultsPage> {
  late Future<GameResults> future;
  bool futureDone = false;
  GameResults? currData;
  late Timer timer;
  late bool confirmRoomExit;

  @override
  void initState() {
    super.initState();
    future = getGameResults(context);
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        if (!mounted && !context.mounted) {
          return;
        } else if (futureDone && currData != null) {
          setState(() {
            futureDone = false;
            future = getGameResults(context);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    future.ignore();
    super.dispose();
  }

  void leaveGame(context) async {
    final isConfirmed = await launchExitConfirmationDialog(
        context,
        "Leave Game Results",
        "Are you sure you want to navigate back to menu?");
    if (!isConfirmed) return;

    try {
      await widget.session.leaveGame();
      if (!context.mounted || !mounted) return;
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
      timer.cancel();
      future.ignore();
      if (!context.mounted || !mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              errorDialogData: ErrorDialogData(
                title: serverConnErrorText,
                message: serverConnErrorText,
              ),
            ),
          ),
          (route) => false);
    } on Error catch (error) {
      showErrorDialog(context, "Failed to leave game", error.format());
    }
  }

  Future<GameResults> getGameResults(BuildContext context) async {
    return await widget.session.getGameResults().onError(
      (Error_ServerConnectionError error, stackTrace) {
        timer.cancel();
        future.ignore();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              errorDialogData: ErrorDialogData(
                title: serverConnErrorText,
                message: error.format(),
              ),
            ),
          ),
        );
        return const GameResults(userAnswers: [], playersResults: []);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Overview'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: gameResultsContents(context),
      ),
    );
  }

  Widget gameResultsContents(context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            currData == null) {
          return Skeletonizer(
              child: GameResultsContent(
            session: widget.session,
            questionsHistory: const [],
            playersResults: fakePlayerResults,
            username: widget.username,
            gameName: widget.gameName,
          ));
        }

        if (snapshot.hasError) {
          currData = null;
          futureDone = true;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text((snapshot.error as Error).format()),
                const SizedBox(
                  height: 16.0,
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      futureDone = false;
                      future = getGameResults(context);
                    });
                  },
                  child: const Text("Try Again"),
                )
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          currData = snapshot.data;
          futureDone = true;
        }

        return Skeletonizer(
          enabled: false,
          child: GameResultsContent(
            username: widget.username,
            gameName: widget.gameName,
            session: widget.session,
            questionsHistory: currData!.userAnswers,
            playersResults: putUserOnTop(currData!.playersResults),
          ),
        );
      },
    );
  }

  List<PlayerResult> putUserOnTop(List<PlayerResult> playersResults) {
    if (!playersResults
        .any((element) => element.player.username == widget.username)) {
      return playersResults;
    }

    final user = playersResults
        .firstWhere((element) => element.player.username == widget.username);
    playersResults.remove(user);
    playersResults.insert(0, user);
    return playersResults;
  }

  void returnToHomepage(context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          session: widget.session,
          username: widget.username,
        ),
      ),
    );
  }
}
