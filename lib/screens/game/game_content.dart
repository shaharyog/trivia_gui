import 'package:flutter/material.dart';
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
  final int seconds;

  const GameContent({
    super.key,
    required this.session,
    required this.question,
    required this.onServerError,
    required this.seconds,
  });

  @override
  State<GameContent> createState() => _GameContentState();
}

class _GameContentState extends State<GameContent> {
  bool _isLoading = false;
  int? _selectedAnswerId;

  void submitAnswer(int answerId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      int correctAnswer = await widget.session.submitAnswer(
          answerId: answerId, questionId: widget.question.questionId);
    } on Error_ServerConnectionError catch (error) {
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
    } on Error catch (error) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: "Error submitting answer",
            message: error.format(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  child: buildQuestionWidget(context),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64.0,
                    vertical: 16.0,
                  ),
                  child: buildAnswersList(context),
                ),
              ),
            ],
          )
        : Row(
            children: [
              const Icon(Icons.timer_sharp),
              Text("${((widget.seconds) ~/ 60).toString().padLeft(2, '0')}: ${(widget.seconds % 60).toString().padLeft(2, '0')}"),
            ],
          );
  }

  Widget buildQuestionWidget(context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            width: 2,
          )),
      padding: const EdgeInsets.all(16),
      child: Text(
        widget.question.question,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height / 30,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
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
        onTap: !_isLoading
            ? () {
                setState(() {
                  _selectedAnswerId = widget.question.answers[index].$1;
                });
                submitAnswer(_selectedAnswerId!);
              }
            : null,
        child: MouseRegion(
          cursor:
              !_isLoading ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Card(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            child: Center(
              child: Text(
                widget.question.answers[index].$2,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: getFontSize(context),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

double getFontSize(BuildContext context, {bool title = false}) {
  return (((MediaQuery.of(context).size.height / 2) - 32) / 4) *
      (title ? 0.4 : 0.25);
}
