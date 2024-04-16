import 'package:flutter/material.dart';
import '../Objects/room.dart';
import 'filters_providers/rooms_filters_provider.dart';

class RoomsProvider with ChangeNotifier {
  List<Room> _rooms = [
    Room(
      uuid: '1',
      name: 'Room 1',
      maxPlayers: 5,
      players: [
        'user1',
        'user2',
        'user3',
      ],
      questionsCount: 10,
      timePerQuestion: 30,
      isActive: false,
    ),
    Room(
      uuid: '2',
      name: 'Room 2',
      maxPlayers: 8,
      players: [
        'user1',
        'user2',
        'user3',
        'user4',
        'user5',
      ],
      questionsCount: 15,
      timePerQuestion: 20,
      isActive: true,
    ),
    Room(
      uuid: '3',
      name: 'Room 3',
      maxPlayers: 6,
      players: [
        'user1',
        'user2',
      ],
      questionsCount: 12,
      timePerQuestion: 25,
      isActive: false,
    ),
  ];

  List<Room> _filteredRooms = [];

  RoomsProvider(this._filtersProvider) {
    _filteredRooms = _rooms;
    _filtersProvider.addListener(_onFiltersChanged);
  }

  final FiltersProvider _filtersProvider;

  List<Room> get filteredRooms => _filteredRooms;

  void _onFiltersChanged() {
    filterRooms();
  }

  void sortRooms(String sortBy) {
    switch (sortBy) {
      case 'questionsCount':
        _filteredRooms
            .sort((a, b) => a.questionsCount.compareTo(b.questionsCount));
        break;
      case 'players':
        _filteredRooms
            .sort((a, b) => a.players.length.compareTo(b.players.length));
        break;
      case 'isActive':
        _filteredRooms.sort((a, b) => a.isActive == b.isActive ? 0 : 1);
        break;
    }
    notifyListeners();
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
            room.players.length >=
                _filtersProvider.playersCountRange.start.round() &&
            room.players.length <=
                _filtersProvider.playersCountRange.end.round() &&
            (_filtersProvider.isActive ? room.isActive : true))
        .toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _filtersProvider.removeListener(_onFiltersChanged);
    super.dispose();
  }
}
