import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/lobby/lobby.dart';
import 'package:trivia/screens/rooms/room_list.dart';
import 'package:trivia/utils/common_functionalities/screen_size.dart';
import '../../consts.dart';
import '../../src/rust/api/request/get_room_players.dart';
import '../../utils/filters.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/request/get_rooms.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';
import 'room_details/room_details_contents.dart';
import 'rooms_components/launch_filter_sheet.dart';
import 'search_bar.dart';

class RoomsWidget extends StatefulWidget {
  final Session session;
  final Filters filters;
  final bool isInCreateRoomSheet;

  const RoomsWidget(
      {super.key,
      required this.session,
      required this.filters,
      required this.isInCreateRoomSheet});

  @override
  State<RoomsWidget> createState() => _RoomsWidgetState();
}

class _RoomsWidgetState extends State<RoomsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkingController;
  late Future<List<Room>> future;
  bool futureDone = false;
  List<Room>? currData;
  late Timer timer;
  TextEditingController searchController = TextEditingController();
  String? selectedRoomId;
  final FocusNode _keyboardFocusNode = FocusNode();
  bool isInRoomDetailsBottomSheet = false;
  bool isInFilterSheet = false;

  @override
  void initState() {
    super.initState();
    searchController.text = widget.filters.searchText;
    _blinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: defaultBlinkingCircleDuration),
    )..repeat(reverse: true);

    future = getRooms(context);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (futureDone && currData != null) {
          setState(() {
            futureDone = false;
            future = getRooms(context);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _blinkingController.dispose();
    timer.cancel();
    future.ignore();
    searchController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isInRoomDetailsBottomSheet &&
          selectedRoomId != null &&
          getScreenSize(context) == ScreenSize.small &&
          currData != null &&
          filterRooms(currData!, widget.filters).any(
            (room) => room.id == selectedRoomId,
          )) {
        if (!isInFilterSheet && !widget.isInCreateRoomSheet) {
          launchRoomDetailsBottomSheet(context, selectedRoomId!);
        } else {
          setState(() {
            selectedRoomId = null;
          });
        }
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 16.0,
                  right: 24.0,
                  left: 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: buildSearchBar(context),
                    ),
                    FutureBuilder(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            currData == null) {
                          return Skeletonizer(
                            child: RoomList(
                              onRoomJoin: (_, __) {},
                              rooms: fakeRooms,
                              blinkingController: _blinkingController,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          currData = null;
                          futureDone = true;
                          double height;
                          if (getScreenSize(context) == ScreenSize.small) {
                            height = MediaQuery.of(context).size.height -
                                208; // screen height - (app bar, search bar, navbar)
                          } else {
                            height = MediaQuery.of(context).size.height -
                                72; // screen height - (search bar)
                          }
                          return SizedBox(
                            height: height,
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
                                      future = getRooms(context);
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
                        // check if selectedRoomId is still in the list
                        if (selectedRoomId != null &&
                            !filterRooms(currData!, widget.filters).any(
                              (room) => room.id == selectedRoomId,
                            )) {
                          selectedRoomId = null;
                        }

                        return RoomList(
                          onRoomJoin: (roomId, roomName) async {
                            try {
                              await widget.session.joinRoom(roomId: roomId);
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Lobby(
                                      session: widget.session,
                                      id: roomId,
                                      roomName: roomName,
                                    );
                                  },
                                ),
                              );
                            } on Error_ServerConnectionError catch (e) {
                              timer.cancel();
                              future.ignore();
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
                            } on Error catch (e) {
                              if (!context.mounted) return;
                              showErrorDialog(
                                  context, "Failed to join room", e.format());
                            }
                          },
                          onRoomSelected: (roomId) {
                            if (getScreenSize(context) == ScreenSize.small) {
                              launchRoomDetailsBottomSheet(
                                context,
                                roomId,
                              );
                            } else {
                              setState(() {
                                if (selectedRoomId == roomId) {
                                  selectedRoomId = null;
                                } else {
                                  selectedRoomId = roomId;
                                }
                              });
                            }
                          },
                          selectedRoomId:
                              getScreenSize(context) == ScreenSize.small
                                  ? null
                                  : selectedRoomId,
                          rooms: filterAndSortRooms(currData!, widget.filters),
                          blinkingController: _blinkingController,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (getScreenSize(context) != ScreenSize.small &&
              selectedRoomId != null &&
              currData != null &&
              filterRooms(currData!, widget.filters).any(
                (room) => room.id == selectedRoomId,
              ))
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SingleChildScrollView(
                  child: RoomDetailsContents(
                    onSwitchToLargeScreen: null,
                    room: currData!.singleWhere(
                      (room) => room.id == selectedRoomId,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<List<Room>> getRooms(BuildContext context) {
    return widget.session.getRooms().onError(
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
        return [];
      },
    );
  }

  List<Room> filterAndSortRooms(List<Room> rooms, Filters filters) {
    return sortRooms(filterRooms(rooms, filters), filters);
  }

  List<Room> filterRooms(List<Room> rooms, Filters filters) {
    return rooms
        .where(
          (room) =>
              // room.id == selectedRoomId ||
              room.roomData.name.toLowerCase().contains(
                    filters.searchText.toLowerCase(),
                  ) &&
              room.roomData.questionCount >=
                  filters.questionCountRange.start.round() &&
              room.roomData.questionCount <=
                  filters.questionCountRange.end.round() &&
              room.players.length >= filters.playersCountRange.start.round() &&
              room.players.length <= filters.playersCountRange.end.round() &&
              (filters.showOnlyActive ? room.isActive : true),
        )
        .toList();
  }

  List<Room> sortRooms(List<Room> rooms, Filters filters) {
    List<Room> sortedRooms = List.from(rooms);
    sortedRooms.sort(
      (a, b) {
        switch (filters.sortBy) {
          case SortBy.isActive:
            return b.isActive ? 1 : -1;
          case SortBy.playersCount:
            return b.players.length.compareTo(a.players.length);
          case SortBy.questionsCount:
            return b.roomData.questionCount.compareTo(a.roomData.questionCount);
          case SortBy.timePerQuestion:
            return b.roomData.timePerQuestion
                .compareTo(a.roomData.timePerQuestion);
          default:
            return 0; // No sorting
        }
      },
    );

    // reverse the list if the sort direction is reversed
    return filters.isReversedSort ? sortedRooms.reversed.toList() : sortedRooms;
  }

  Future<List<Player>> getRoomPlayers(context, roomId) async {
    final players = widget.session.getRoomPlayers(roomId: roomId).onError(
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
        return [];
      },
    );

    return players;
  }

  void launchRoomDetailsBottomSheet(context, roomId) async {
    setState(() {
      selectedRoomId = null;
      isInRoomDetailsBottomSheet = true;
    });
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return RoomDetailsContents(
          onSwitchToLargeScreen: () {
            selectedRoomId = roomId;
          },
          isBottomSheet: true,
          room: currData!.singleWhere(
            (room) => room.id == roomId,
          ),
        );
      },
    );
    setState(() {
      isInRoomDetailsBottomSheet = false;
    });
  }

  Widget buildSearchBar(context) {
    return SearchBarCustom(
      backgroundColor: WidgetStateColor.resolveWith(
        (states) => Theme.of(context).colorScheme.surface,
      ),
      controller: searchController,
      onChanged: (value) {
        setState(() {
          widget.filters.searchText = value;
        });
      },
      surfaceTintColor: WidgetStateColor.resolveWith(
        (states) => Theme.of(context).colorScheme.primary,
      ),
      hintText: 'Search rooms',
      leading: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(Icons.search_sharp),
      ),
      trailing: <Widget>[
        IconButton(
          onPressed: () {
            setState(
              () {
                setState(() {
                  widget.filters.isReversedSort =
                      !widget.filters.isReversedSort;
                });
              },
            );
          },
          icon: Icon(
            widget.filters.isReversedSort
                ? Icons.arrow_downward_sharp
                : Icons.arrow_upward_sharp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        GestureDetector(
          onLongPress: () {
            setState(() {
              widget.filters.resetSort();
            });
          },
          child: PopupMenuButton<SortBy>(
            tooltip: '',
            icon: Icon(
              Icons.sort_sharp,
              color: Theme.of(context).colorScheme.primary,
            ),
            onSelected: (SortBy selectedSortBy) {
              setState(() {
                widget.filters.sortBy = selectedSortBy;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              PopupMenuItem<SortBy>(
                value: SortBy.isActive,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.check_circle_sharp,
                        color: widget.filters.sortBy == SortBy.isActive
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    Text(
                      'Sort by Active Status',
                      style: TextStyle(
                        color: widget.filters.sortBy == SortBy.isActive
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<SortBy>(
                value: SortBy.playersCount,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.people_sharp,
                        color: widget.filters.sortBy == SortBy.playersCount
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    Text(
                      'Sort by Number of Online Players',
                      style: TextStyle(
                        color: widget.filters.sortBy == SortBy.playersCount
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<SortBy>(
                value: SortBy.questionsCount,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.question_mark_sharp,
                        color: widget.filters.sortBy == SortBy.questionsCount
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    Text(
                      'Sort by Number of Questions',
                      style: TextStyle(
                        color: widget.filters.sortBy == SortBy.questionsCount
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<SortBy>(
                value: SortBy.timePerQuestion,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.timer_sharp,
                        color: widget.filters.sortBy == SortBy.timePerQuestion
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    Text(
                      'Sort by Time Per Question',
                      style: TextStyle(
                        color: widget.filters.sortBy == SortBy.timePerQuestion
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onLongPress: () {
            setState(() {
              widget.filters.resetFilters();
            });
          },
          child: IconButton(
            onPressed: () async {
              setState(() {
                isInFilterSheet = true;
              });
              Filters? newFilters = await launchFilterSheet(
                context,
                widget.filters,
              );
              if (newFilters != null) {
                setState(() {
                  widget.filters.updateFrom(newFilters);
                });
              }
              setState(() {
                isInFilterSheet = false;
              });
            },
            icon: Icon(
              Icons.tune_sharp,
              color: widget.filters.isFiltering()
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
