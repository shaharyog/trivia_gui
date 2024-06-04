import 'package:flutter/material.dart';
import 'package:trivia/screens/game/question.dart';
import 'package:trivia/src/rust/api/request/get_question.dart';

import '../../consts.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';

class Game extends StatefulWidget {
  final Session session;

  const Game({super.key, required this.session});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Future<Question> future;

  Future<Question> getQuestion() {
    return widget.session.getQuestion().onError(
      (Error_ServerConnectionError error, stackTrace) {
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
        return const Question(question: "", answers: []);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    future = getQuestion();
  }

  @override
  void dispose() {
    future.ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return QuestionWidget(question: snapshot.data!, isSmallScreen: false);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
