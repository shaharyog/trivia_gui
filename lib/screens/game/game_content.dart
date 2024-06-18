import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../consts.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/request/get_question.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';

class GameContent extends StatefulWidget {
  final Session session;
  final Question question;
  final Function onServerError;
  final int currentMilliseconds;
  final int timePerQuestion;
  final int questionCount;
  final Function(bool, int) onAnswerReceived;

  const GameContent({
    super.key,
    required this.session,
    required this.question,
    required this.onServerError,
    required this.currentMilliseconds,
    required this.timePerQuestion,
    required this.questionCount,
    required this.onAnswerReceived,
  });

  @override
  State<GameContent> createState() => _GameContentState();
}

class _GameContentState extends State<GameContent> {
  bool _isWaitingForAnswer = false;
  int? _selectedAnswerId;
  int? _correctAnswerId;

  void submitAnswer(int answerId) async {
    setState(() {
      _isWaitingForAnswer = true;
    });
    try {
      _correctAnswerId = await widget.session.submitAnswer(
        answerId: answerId,
        questionId: widget.question.questionId,
      );
      widget.onAnswerReceived(
          _correctAnswerId == answerId, widget.question.questionId);
      setState(() {});
    } on Error_ServerConnectionError catch (error) {
      _selectedAnswerId = null;
      _correctAnswerId = null;
      if (mounted ) {
        widget.onServerError;
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
      }
    } on Error catch (_) {
      _selectedAnswerId = null;
      _correctAnswerId = null;
      // ignore
    } finally {
      if (mounted || context.mounted) {
        setState(() {
          _isWaitingForAnswer = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowAnswerView =
        widget.currentMilliseconds / 1000 >= widget.timePerQuestion &&
            !Skeletonizer.of(context).enabled;
    if (shouldShowAnswerView && _selectedAnswerId == null) {
      return Center(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (widget.timePerQuestion +
                  5 -
                  (widget.currentMilliseconds / 1000)) /
                  5,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_off_sharp, size: 64.0),
                    const SizedBox(height: 16.0),
                    Text(
                      "Times up!",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      );
    }
    return Column(
      children: [
        !shouldShowAnswerView
            ? LinearProgressIndicator(
                value: (widget.timePerQuestion -
                        (widget.currentMilliseconds / 1000)) /
                    widget.timePerQuestion,
              )
            : LinearProgressIndicator(
                value: (widget.timePerQuestion +
                        5 -
                        (widget.currentMilliseconds / 1000)) /
                    5,
              ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: buildQuestionWidget(context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: buildAnswersList(context),
          ),
        ),
      ],
    );
  }

  Widget buildQuestionWidget(context) {
    return Text(
      widget.question.question,
      style: Theme.of(context).textTheme.displaySmall,
      overflow: TextOverflow.visible,
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }

  Widget buildAnswersList(context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
            child: createAnswer(
              0,
              context,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
            child: createAnswer(
              1,
              context,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
            child: createAnswer(
              2,
              context,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: createAnswer(
              3,
              context,
            ),
          ),
        ),
      ],
    );
  }

  Widget createAnswer(int index, BuildContext context) {
    bool shouldShowAnswer = widget.currentMilliseconds / 1000 >= widget.timePerQuestion &&
        !Skeletonizer.of(context).enabled;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: !_isWaitingForAnswer && !shouldShowAnswer
            ? () {
                setState(() {
                  _selectedAnswerId = widget.question.answers[index].$1;
                });
                submitAnswer(_selectedAnswerId!);
              }
            : null,
        child: MouseRegion(
          cursor: !_isWaitingForAnswer && !shouldShowAnswer
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: Card(
            color: getCardColor(
                selectedIndex: _selectedAnswerId,
                correctIndex: _correctAnswerId,
                cardIndex: index,
                context: context),
            child: Center(
              child: AutoSizeText(
                widget.question.answers[index].$2,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Color getCardColor(
    {required int? selectedIndex,
    int? correctIndex,
    required int cardIndex,
    required BuildContext context}) {
  if (correctIndex != null) {
    if (cardIndex == correctIndex) {
      return const Color(0xff00ab00);
    }
    if (selectedIndex == cardIndex) {
      return Colors.red;
    }
  } else if (selectedIndex == cardIndex) {
    return Theme.of(context).colorScheme.primary.withOpacity(0.4);
  }
  return Theme.of(context).colorScheme.primary.withOpacity(0.15);
}
