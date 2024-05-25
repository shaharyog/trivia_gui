import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/leaderboard/leaderboard_content.dart';
import '../../consts.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/request/get_room_players.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';

class Leaderboard extends StatefulWidget {
  final Session session;

  const Leaderboard({super.key, required this.session});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late Future<List<Player>> future;
  bool futureDone = false;
  List<Player>? currData;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    future = getHighScores(context);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (futureDone && currData != null) {
          setState(() {
            futureDone = false;
            future = getHighScores(context);
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

  Future<List<Player>> getHighScores(BuildContext context) {
    return widget.session.getHighscores().onError(
      (Error_ServerConnectionError error, stackTrace) {
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
        return [];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            currData == null) {
          return const Skeletonizer(
            child: LeaderboardContent(players: fakeHighScoresPlayers),
          );
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
                      future = getHighScores(context);
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

        return Skeletonizer(enabled: false, child: LeaderboardContent(players: currData!));
      },
    );
  }
}
