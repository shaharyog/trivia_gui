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
      _correctAnswerId = null;
      if (mounted) {
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
      _correctAnswerId = null;
      // ignore
    } finally {
      if (mounted) {
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
    if (shouldShowAnswerView) {
      return Column(
        children: [
          LinearProgressIndicator(
            value: (widget.timePerQuestion +
                    5 -
                    (widget.currentMilliseconds / 1000)) /
                5,
          ),
          buildAnswerView(context),
        ],
      );
    }

    return Column(
      children: [
        LinearProgressIndicator(
          value:
              (widget.timePerQuestion - (widget.currentMilliseconds / 1000)) /
                  widget.timePerQuestion,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16.0,
          ),
          child: buildQuestionWidget(context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 64.0,
              vertical: 16.0,
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
      style: Theme.of(context).textTheme.displayMedium,
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
            padding: const EdgeInsets.only(bottom: 8.0),
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
            padding: const EdgeInsets.only(top: 8),
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
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: !_isWaitingForAnswer
            ? () {
                setState(() {
                  _selectedAnswerId = widget.question.answers[index].$1;
                });
                submitAnswer(_selectedAnswerId!);
              }
            : null,
        child: MouseRegion(
          cursor: !_isWaitingForAnswer
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: Card(
            color: _selectedAnswerId == index
                ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                : Theme.of(context).colorScheme.primary.withOpacity(0.15),
            child: Center(
              child: Text(
                widget.question.answers[index].$2,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: getFontSize(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAnswerView(BuildContext context) {
    if (_isWaitingForAnswer) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_selectedAnswerId == null || _correctAnswerId == null) {
      return Text("Time's up!, you better hurry next question");
    } else if (_correctAnswerId == _selectedAnswerId) {
      return Text(" Correct!");
    } else {
      return Text("Wrong");
    }
  }
}

double getFontSize(BuildContext context, {bool title = false}) {
  return (((MediaQuery.of(context).size.height / 2) - 32) / 4) *
      (title ? 0.4 : 0.25);
}
