import 'package:flutter/material.dart';
import '../Objects/room.dart';
import 'filters_providers/rooms_filters_provider.dart';

enum SortBy { isActive, playersCount, questionsCount, timePerQuestion }

class RoomsProvider with ChangeNotifier {
  final List<Room> _rooms = [];
  //   Room(
  //     uuid: '1',
  //     name: 'Room 1',
  //     maxPlayers: 5,
  //     playersCount: 5,
  //     questionsCount: 10,
  //     timePerQuestion: 30,
  //     isActive: false,
  //   ),
  //   Room(
  //     uuid: '2',
  //     name: 'Room 2',
  //     maxPlayers: 8,
  //     playersCount: 7,
  //     questionsCount: 15,
  //     timePerQuestion: 20,
  //     isActive: true,
  //   ),
  //   Room(
  //     uuid: '3',
  //     name: 'Room 3',
  //     maxPlayers: 6,
  //     playersCount: 2,
  //     questionsCount: 12,
  //     timePerQuestion: 25,
  //     isActive: false,
  //   ),
  // ];

  List<Room> _filteredRooms = [];

  RoomsProvider(this._filtersProvider) {
    _filteredRooms = List.from(_rooms);
    sortRooms();
    _filtersProvider.addListener(_onFiltersChanged);
  }

  final FiltersProvider _filtersProvider;

  List<Room> get filteredRooms => _filteredRooms;

  void _onFiltersChanged() {
    filterRooms();
  }

  void filterRooms() {
    _filteredRooms = _rooms
        .where((room) =>
            room.name
                .toLowerCase()
                .contains(_filtersProvider.searchText.toLowerCase()) &&
            room.questionsCount >=
                _filtersProvider.questionCountRange.start.round() &&
            room.questionsCount <=
                _filtersProvider.questionCountRange.end.round() &&
            room.playersCount >=
                _filtersProvider.playersCountRange.start.round() &&
            room.playersCount <=
                _filtersProvider.playersCountRange.end.round() &&
            (_filtersProvider.showOnlyActive ? room.isActive : true))
        .toList();

    sortRooms();
    notifyListeners();
  }

  void sortRooms() {
    _filteredRooms = sortRoomsBy(_filtersProvider.sortBy, _filteredRooms);
    notifyListeners();
  }


  List<Room> sortRoomsBy(SortBy sortBy, List<Room> rooms) {
    List<Room> sortedRooms = List.from(rooms);
    sortedRooms.sort((a, b) {
      switch (_filtersProvider.sortBy) {
        case SortBy.isActive:
          return b.isActive ? 1 : -1;
        case SortBy.playersCount:
          return b.playersCount.compareTo(a.playersCount);
        case SortBy.questionsCount:
          return b.questionsCount.compareTo(a.questionsCount);
        case SortBy.timePerQuestion:
          return b.timePerQuestion.compareTo(a.timePerQuestion);
        default:
          return 0; // No sorting if 'nothing' is selected
      }
    });
    return _filtersProvider.isReversedSort ? sortedRooms.reversed.toList() : sortedRooms;
  }
  void addRoom(Room room) {
    _rooms.add(room);
    filterRooms();
    notifyListeners();
  }

  @override
  void dispose() {
    _filtersProvider.removeListener(_onFiltersChanged);
    super.dispose();
  }
}
