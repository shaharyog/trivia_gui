import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/homepage/homepage.dart';
import 'package:trivia/screens/rooms/room_details/room_details_contents.dart';
import 'package:trivia/src/rust/api/request/create_room.dart';
import 'package:trivia/src/rust/api/request/get_rooms.dart';
import 'package:trivia/utils/common_widgets/toggle_theme_button.dart';

import '../../consts.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/request/get_room_state.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';

class Lobby extends StatefulWidget {
  final Session session;
  final String id;
  final String roomName;
  final bool isAdmin;
  final String username;

  const Lobby(
      {super.key,
      required this.session,
      required this.id,
      required this.roomName,
      required this.isAdmin,
      required this.username});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  late Future<RoomState> future;
  bool futureDone = false;
  RoomState? currData;
  late Timer timer;
  late bool confirmRoomExit;

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

  Future<RoomState> getRoomState(BuildContext context) async {
    RoomState roomState = await widget.session.getRoomState().onError(
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
            questionCount: 0,
            answerTimeout: 0,
            maxPlayers: 0,
            isClosed: false);
      },
    );
    if (roomState.isClosed && context.mounted) {
      returnToHomepage(context);
    }
    return roomState;
  }

  Room roomStateToRoom(RoomState roomState) {
    return Room(
      id: widget.id,
      roomData: RoomData(
        name: widget.roomName,
        maxPlayers: roomState.maxPlayers,
        questionCount: roomState.questionCount,
        timePerQuestion: roomState.answerTimeout,
      ),
      players: roomState.players,
      isActive: roomState.hasGameBegun,
      isFinished: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.isAdmin && currData != null && currData!.players.length > 1
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.play_arrow_sharp),
            )
          : null,
      appBar: AppBar(
        title: const Text("Lobby"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: themeToggleButton(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              icon: Icon(
                widget.isAdmin ? Icons.close_sharp : Icons.exit_to_app_sharp,
              ),
              onPressed: () async {
                confirmRoomExit = false;
                await launchExitConfirmationDialog(context);
                if (!confirmRoomExit) return;
                try {
                  if (widget.isAdmin) {
                    widget.session.closeRoom();
                  } else {
                    widget.session.leaveRoom();
                  }

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
                } on Error_ServerConnectionError catch (e) {
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        errorDialogData: ErrorDialogData(
                          title: serverConnErrorText,
                          message: e.format(),
                        ),
                      ),
                    ),
                  );
                } catch (e) {
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
                }
              },
            ),
          ),
        ],
      ),
      body: roomLobbyContent(context),
    );
  }

  Widget roomLobbyContent(context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            currData == null) {
          return Skeletonizer(
            child: RoomDetailsContents(
              username: widget.username,
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
            username: widget.username,
            room: roomStateToRoom(currData!),
          ),
        );
      },
    );
  }

  Future<void> launchExitConfirmationDialog(context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            widget.isAdmin ? "Close Room" : "Exit Room",
          ),
          content: Text(
            widget.isAdmin
                ? "Are you sure you want to close this room?"
                : "Are you sure you want to leave this room?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                confirmRoomExit = true;
                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
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
