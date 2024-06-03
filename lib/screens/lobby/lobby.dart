import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/rooms/room_details/room_details_contents.dart';
import 'package:trivia/src/rust/api/request/create_room.dart';
import 'package:trivia/src/rust/api/request/get_rooms.dart';

import '../../consts.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/request/get_room_players.dart';
import '../../src/rust/api/request/get_room_state.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';

class Lobby extends StatefulWidget {
  final Session session;
  final String id;
  final String roomName;

  const Lobby(
      {super.key,
      required this.session,
      required this.id,
      required this.roomName});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  late Future<RoomState> future;
  bool futureDone = false;
  RoomState? currData;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    future = getRoomState(context);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (futureDone && currData != null) {
          setState(() {
            futureDone = false;
            future = getRoomState(context);
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

  Future<RoomState> getRoomState(BuildContext context) {
    return widget.session.getRoomState().onError(
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
        return const RoomState(
            hasGameBegun: false,
            players: [],
            questionsCount: 0,
            answerTimeout: 0,
            maxPlayers: 0,
            isClosed: false);
      },
    );
  }

  Room roomStateToRoom(RoomState roomState) {
    return Room(
      id: widget.id,
      roomData: RoomData(
        name: widget.roomName,
        maxPlayers: roomState.maxPlayers,
        questionCount: roomState.questionsCount,
        timePerQuestion: roomState.answerTimeout,
      ),
      players: roomState.players,
      isActive: roomState.hasGameBegun,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            currData == null) {
          return Skeletonizer(
            child: RoomDetailsContents(
              room: roomStateToRoom(fakeRoomState),
            ),
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
                      future = getRoomState(context);
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
          child: RoomDetailsContents(
            room: roomStateToRoom(currData!),
          ),
        );
      },
    );
  }
}
