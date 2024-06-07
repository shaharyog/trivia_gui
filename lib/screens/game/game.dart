import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/homepage/homepage.dart';
import 'package:trivia/screens/game/game_content.dart';
import 'package:trivia/src/rust/api/request/get_question.dart';
import 'package:trivia/utils/common_widgets/toggle_theme_button.dart';
import '../../consts.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';
import 'game_results/game_results.dart';

class Game extends StatefulWidget {
  final Session session;
  final int timePerQuestion;
  final int questionCount;
  final String gameName;
  final String username;

  const Game({
    super.key,
    required this.session,
    required this.timePerQuestion,
    required this.questionCount,
    required this.gameName,
    required this.username,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Future<Question> currQuestionFuture;
  int currQuestionId = 0;
  late Timer questionsTimer;
  late Timer durationTimer;
  int currentSeconds = 0;
  bool startedTimer = false;

  Future<Question> getQuestion(context) async {
    final question = await widget.session.getQuestion().onError(
      (Error_ServerConnectionError error, stackTrace) {
        currQuestionFuture.ignore();
        questionsTimer.cancel();
        durationTimer.cancel();
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
        return const Question(questionId: -1, question: "", answers: []);
      },
    );
    currQuestionId = question.questionId;
    if (currQuestionId == widget.questionCount - 1) {
      questionsTimer.cancel();
      durationTimer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameResultsPage(
            session: widget.session,
            username: widget.username,
          ),
        ),
      );
    }
    startedTimer = false;
    return question;
  }

  void startTimer(context) {
    durationTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (context.mounted) {
          setState(() {
            currentSeconds = timer.tick;
          });
        }
        if (timer.tick >= widget.timePerQuestion || widget.session.isDisposed) {
          timer.cancel();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    currQuestionFuture = getQuestion(context);
    questionsTimer = Timer.periodic(
      Duration(seconds: widget.timePerQuestion),
      (timer) {
        if (currQuestionId >= widget.questionCount - 1) {
          timer.cancel();
        } else if (context.mounted) {
          setState(() {
            currQuestionFuture = getQuestion(context);
          });
        }
      },
    );
  }

  void leaveGame(context) async {
    final isConfirmed = await launchExitConfirmationDialog(context, "Leave Game", "Are you sure you want to leave the game? (you will be punished)");
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
      currQuestionFuture.ignore();
      questionsTimer.cancel();
      durationTimer.cancel();
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

  @override
  void dispose() {
    currQuestionFuture.ignore();
    questionsTimer.cancel();
    durationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game - ${widget.gameName}"),
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
      body: FutureBuilder(
        future: currQuestionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              child: GameContent(
                seconds: widget.timePerQuestion - currentSeconds,
                onServerError: () {},
                question: fakeQuestion,
                session: widget.session,
                // in the future some fake data
              ),
            );
          }
          if (snapshot.hasError) {
            if (snapshot.error is Error && (snapshot.error as Error).format() == "Game is already finished") {
              questionsTimer.cancel();
              durationTimer.cancel();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GameResultsPage(
                    session: widget.session,
                    username: widget.username,
                  ),
                ),
              );
            }
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
                        currQuestionFuture = getQuestion(context);
                      });
                    },
                    child: const Text("Try Again"),
                  )
                ],
              ),
            );
          }

          final question = snapshot.data!;
          if (!startedTimer) {
            startTimer(context);
            startedTimer = true;
          }
          return GameContent(
            seconds: widget.timePerQuestion - currentSeconds,
            onServerError: () {
              // ignore timer
              questionsTimer.cancel();
              durationTimer.cancel();
              currQuestionFuture.ignore();
            },
            session: widget.session,
            question: question,
          );
        },
      ),
    );
  }
}

Future<bool> launchExitConfirmationDialog(context, String title, String message) async {
  bool isConfirmed = false;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              isConfirmed = true;
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      );
    },
  );

  return isConfirmed;
}
