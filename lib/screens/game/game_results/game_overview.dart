import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trivia/src/rust/api/request/get_game_results.dart';
import 'package:trivia/utils/common_functionalities/seconds_to_readable.dart';
import '../../../consts.dart';
import '../../../homepage/homepage.dart';
import '../../../src/rust/api/error.dart';
import '../../../src/rust/api/session.dart';
import '../../../utils/common_widgets/toggle_theme_button.dart';
import '../../../utils/dialogs/error_dialog.dart';
import '../../auth/login.dart';

class GameOverview extends StatefulWidget {
  final Session session;
  final String username;

  final List<QuestionAnswered> questionsHistory;

  const GameOverview(
      {super.key,
      required this.session,
      required this.username,
      required this.questionsHistory});

  @override
  State<GameOverview> createState() => _GameOverviewState();
}

class _GameOverviewState extends State<GameOverview> {
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        title: const Text('Game Overview'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(
              secondsToReadableTime(
                  widget.questionsHistory[_currentQuestionIndex].timeTaken),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: _currentQuestionIndex > 0
                    ? () {
                        setState(() {
                          _currentQuestionIndex--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.arrow_back_ios_sharp)),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: getPage(_currentQuestionIndex),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 12.0,
                      children: List.generate(
                        widget.questionsHistory.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              border: index == _currentQuestionIndex
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      width: 1)
                                  : null,
                              shape: BoxShape.circle,
                              color: getColorByStatus(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed:
                    _currentQuestionIndex < widget.questionsHistory.length - 1
                        ? () {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          }
                        : null,
                icon: const Icon(Icons.arrow_forward_ios_sharp)),
          ],
        ),
      ),
    );
  }

  Widget getPages(val, int index) {
    return getPage(index);
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
      if (!context.mounted || !mounted) return;
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

  Widget buildQuestionWidget(context, int questionIndex) {
    return Text(
      widget.questionsHistory[questionIndex].question,
      style: Theme.of(context).textTheme.displaySmall,
      overflow: TextOverflow.visible,
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }

  Widget buildAnswersList(context, int questionIndex) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
            child: createAnswer(
              0,
              context,
              questionIndex,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
            child: createAnswer(
              1,
              context,
              questionIndex,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
            child: createAnswer(
              2,
              context,
              questionIndex,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: createAnswer(
              3,
              context,
              questionIndex,
            ),
          ),
        ),
      ],
    );
  }

  Widget createAnswer(int index, BuildContext context, int questionIndex) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        child: Card(
          color: getCardColor(
              answerIndex: widget.questionsHistory[questionIndex].userAnswer,
              correctIndex:
                  widget.questionsHistory[questionIndex].correctAnswer,
              cardIndex: index,
              context: context),
          child: Center(
            child: AutoSizeText(
              widget.questionsHistory[questionIndex].answers[index],
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget getPage(int questionIndex) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16.0,
          ),
          child: buildQuestionWidget(context, questionIndex),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: buildAnswersList(context, questionIndex),
          ),
        ),
      ],
    );
  }

  Color getColorByStatus(int index) {
    if (widget.questionsHistory[index].userAnswer > 4) {
      return Colors.blueGrey;
    } else if (widget.questionsHistory[index].userAnswer ==
        widget.questionsHistory[index].correctAnswer) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

Future<bool> launchExitConfirmationDialog(
    context, String title, String message) async {
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

Color getCardColor(
    {int? answerIndex,
    required int correctIndex,
    required int cardIndex,
    required BuildContext context}) {
  if (answerIndex != null) {
    if (answerIndex == cardIndex && answerIndex != correctIndex) {
      return Colors.red;
    }
  }
  if (cardIndex == correctIndex) {
    return const Color(0xff00ab00);
  }
  return Theme.of(context).colorScheme.primary.withOpacity(0.15);
}
