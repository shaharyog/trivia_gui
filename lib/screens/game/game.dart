import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/game/game_content.dart';
import 'package:trivia/screens/rooms/rooms_components/blinking_circle.dart';
import 'package:trivia/src/rust/api/request/get_question.dart';
import 'package:trivia/utils/common_widgets/toggle_theme_button.dart';
import '../../consts.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';
import 'game_results/game_results.dart';

enum AnswerStatus {
  correct,
  incorrect,
  notAnswered,
}

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

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  late Future<Question> currQuestionFuture;
  int currQuestionId = 0;
  late Timer questionsTimer;
  late Timer durationTimer;
  int currentMilliseconds = 0;
  late List<AnswerStatus> answerStatuses;
  late AnimationController _blinkingController;

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
    setState(() {
      currQuestionId = question.questionId;
    });
    return question;
  }

  void startQuestionTimer(context) {
    durationTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        if (context.mounted || !context.mounted) {
          setState(() {
            currentMilliseconds = timer.tick * 16;
          });
        } else {
          timer.cancel();
          return;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _blinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: defaultBlinkingCircleDuration),
    )..repeat(reverse: true);
    answerStatuses =
        List.filled(widget.questionCount, AnswerStatus.notAnswered);
    startQuestionTimer(context);
    currQuestionFuture = getQuestion(context);
    questionsTimer = Timer.periodic(
      Duration(seconds: widget.timePerQuestion + 5),
      (timer) {
        if (currQuestionId == widget.questionCount - 1) {
          timer.cancel();
          durationTimer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameResultsPage(
                gameName: widget.gameName,
                session: widget.session,
                username: widget.username,
              ),
            ),
          );
        }

        if (currQuestionId >= widget.questionCount - 1) {
          timer.cancel();
        } else if (context.mounted || mounted) {
          durationTimer.cancel();
          setState(() {
            currentMilliseconds = 0;
          });
          startQuestionTimer(context);
          setState(() {
            currQuestionFuture = getQuestion(context);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    currQuestionFuture.ignore();
    questionsTimer.cancel();
    durationTimer.cancel();
    _blinkingController.dispose();
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
            child: Text("${currQuestionId + 1} / ${widget.questionCount}"),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: themeToggleButton(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: FutureBuilder(
              future: currQuestionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    child: GameContent(
                      onAnswerReceived: (_, __) {},
                      currentMilliseconds: 0,
                      onServerError: () {},
                      question: fakeQuestion,
                      session: widget.session,
                      timePerQuestion: widget.timePerQuestion,
                      questionCount: widget.questionCount,
                      // in the future some fake data
                    ),
                  );
                }
                if (snapshot.hasError) {
                  if (snapshot.error is Error &&
                      (snapshot.error as Error).format() ==
                          "Game is already finished") {
                    questionsTimer.cancel();
                    durationTimer.cancel();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameResultsPage(
                          gameName: widget.gameName,
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
                return Skeletonizer(
                  enabled: false,
                  child: GameContent(
                    currentMilliseconds: currentMilliseconds,
                    onServerError: () {
                      // ignore timer
                      questionsTimer.cancel();
                      durationTimer.cancel();
                      currQuestionFuture.ignore();
                    },
                    onAnswerReceived: (correct, questionId) {
                      setState(() {
                        answerStatuses[questionId] = correct
                            ? AnswerStatus.correct
                            : AnswerStatus.incorrect;
                      });
                    },
                    session: widget.session,
                    question: question,
                    timePerQuestion: widget.timePerQuestion,
                    questionCount: widget.questionCount,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 12.0,
              children: List.generate(
                widget.questionCount,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: (index == currQuestionId &&
                          (currentMilliseconds / 1000) < widget.timePerQuestion)
                      ? BlinkingCircle(
                          animationController: _blinkingController,
                          color: Colors.grey,
                        )
                      : Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
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
    );
  }

  Color getColorByStatus(int index) {
    if (answerStatuses[index] == AnswerStatus.correct) {
      return Colors.green;
    } else if (answerStatuses[index] == AnswerStatus.incorrect) {
      return Colors.red;
    } else {
      return index <= currQuestionId ? Colors.blueGrey : Colors.grey;
    }
  }
}
