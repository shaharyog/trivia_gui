import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/rooms/room_list.dart';
import '../../consts.dart';
import '../../providers/filters_providers/filters.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/request/get_rooms.dart';
import '../../src/rust/api/session.dart';
import '../../utils/common_functionalities/reset_providers.dart';
import '../../utils/dialogs/error_dialog.dart';
import 'rooms_components/launch_filter_sheet.dart';
import 'search_bar.dart';

class RoomsWidget extends StatefulWidget {
  final Session session;
  final Filters filters;
  final ValueChanged<Filters> onFiltersChanged;

  const RoomsWidget({
    super.key,
    required this.session,
    required this.filters,
    required this.onFiltersChanged,
  });

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

  @override
  void initState() {
    super.initState();
    searchController.text = widget.filters.searchText;
    _blinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: defaultBlinkingCircleDuration),
    )..repeat(reverse: true);

    future = getRooms(context);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (futureDone && currData != null) {
        setState(() {
          futureDone = false;
          future = getRooms(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _blinkingController.dispose();
    timer.cancel();
    future.ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBarCustom(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        widget.filters.searchText = value;
                      });
                    },
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
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<SortBy>>[
                            PopupMenuItem<SortBy>(
                              value: SortBy.isActive,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.check_circle_sharp,
                                      color: widget.filters.sortBy ==
                                              SortBy.isActive
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Active Status',
                                    style: TextStyle(
                                      color: widget.filters.sortBy ==
                                              SortBy.isActive
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                                      color: widget.filters.sortBy ==
                                              SortBy.playersCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Number of Online Players',
                                    style: TextStyle(
                                      color: widget.filters.sortBy ==
                                              SortBy.playersCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                                      color: widget.filters.sortBy ==
                                              SortBy.questionsCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Number of Questions',
                                    style: TextStyle(
                                      color: widget.filters.sortBy ==
                                              SortBy.questionsCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                                      color: widget.filters.sortBy ==
                                              SortBy.timePerQuestion
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Time Per Question',
                                    style: TextStyle(
                                      color: widget.filters.sortBy ==
                                              SortBy.timePerQuestion
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                            Filters? newFilters = await launchFilterSheet(
                                context, widget.filters);
                            if (newFilters != null) {
                              setState(() {
                                widget.filters.updateFrom(newFilters);
                              });
                            }
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
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      currData == null) {
                    return Skeletonizer(
                      child: RoomList(
                        rooms: fakeRooms,
                        blinkingController: _blinkingController,
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

                  return RoomList(
                    rooms: filterAndSortRooms(currData!, widget.filters),
                    blinkingController: _blinkingController,
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<List<Room>> getRooms(BuildContext context) {
    return widget.session
        .getRooms()
        .onError((Error_ServerConnectionError error, stackTrace) {
      // logout when server connection error occurred
      resetProviders(context);
      Future.microtask(
        () {
          Navigator.of(context).pushReplacementNamed('/login');
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return ErrorDialog(
                  title: "Server Connection Error",
                  message: "${error.format()}, Returning to login page...");
            },
          );
        },
      );
      return [];
    });
  }

  List<Room> filterAndSortRooms(List<Room> rooms, Filters filters) {
    return sortRooms(filterRooms(rooms, filters), filters);
  }

  List<Room> filterRooms(List<Room> rooms, Filters filters) {
    return rooms
        .where(
          (room) =>
              room.roomData.name.toLowerCase().contains(
                    filters.searchText.toLowerCase(),
                  ) &&
              room.roomData.questionCount >=
                  filters.questionCountRange.start.round() &&
              room.roomData.questionCount <=
                  filters.questionCountRange.end.round() &&
              // currently not filtering by players count, because the request from the server does not return it
              // room.roomData.playersCount >=
              //     filters.playersCountRange.start.round() &&
              // room.playersCount <= filters.playersCountRange.end.round() &&
              (filters.showOnlyActive ? room.isActive : true),
        )
        .toList();
  }

  List<Room> sortRooms(List<Room> rooms, Filters filters) {
    List<Room> sortedRooms = List.from(rooms);
    sortedRooms.sort((a, b) {
      switch (filters.sortBy) {
        case SortBy.isActive:
          return b.isActive ? 1 : -1;
        // case SortBy.playersCount:
        //   return b.roomData.playersCount.compareTo(a.roomData.playersCount);
        case SortBy.questionsCount:
          return b.roomData.questionCount.compareTo(a.roomData.questionCount);
        case SortBy.timePerQuestion:
          return b.roomData.timePerQuestion
              .compareTo(a.roomData.timePerQuestion);
        default:
          return 0; // No sorting
      }
    });

    // reverse the list if the sort direction is reversed
    return filters.isReversedSort ? sortedRooms.reversed.toList() : sortedRooms;
  }
}
