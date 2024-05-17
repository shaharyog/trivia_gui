// import 'package:flutter/material.dart';
// import '../objects/room.dart';
// import 'filters_providers/rooms_filters_provider.dart';
//
// enum SortBy { isActive, playersCount, questionsCount, timePerQuestion }
//
// class RoomsProvider with ChangeNotifier {
//   final List<Room> _rooms = [];
//   List<Room> _filteredRooms = [];
//
//   RoomsProvider(this._filtersProvider) {
//     _filteredRooms = List.from(_rooms);
//     sortRooms();
//     _filtersProvider.addListener(_onFiltersChanged);
//   }
//
//   final FiltersProvider _filtersProvider;
//
//   List<Room> get filteredRooms => _filteredRooms;
//
//   void _onFiltersChanged() {
//     filterRooms();
//   }
//
//   void filterRooms() {
//     _filteredRooms = _rooms
//         .where((room) =>
//             room.name
//                 .toLowerCase()
//                 .contains(_filtersProvider.searchText.toLowerCase()) &&
//             room.questionsCount >=
//                 _filtersProvider.questionCountRange.start.round() &&
//             room.questionsCount <=
//                 _filtersProvider.questionCountRange.end.round() &&
//             room.playersCount >=
//                 _filtersProvider.playersCountRange.start.round() &&
//             room.playersCount <=
//                 _filtersProvider.playersCountRange.end.round() &&
//             (_filtersProvider.showOnlyActive ? room.isActive : true))
//         .toList();
//
//     sortRooms();
//     notifyListeners();
//   }
//
//   void sortRooms() {
//     _filteredRooms = sortRoomsBy(_filtersProvider.sortBy, _filteredRooms);
//     notifyListeners();
//   }
//
//   List<Room> sortRoomsBy(SortBy sortBy, List<Room> rooms) {
//     List<Room> sortedRooms = List.from(rooms);
//     sortedRooms.sort((a, b) {
//       switch (_filtersProvider.sortBy) {
//         case SortBy.isActive:
//           return b.isActive ? 1 : -1;
//         case SortBy.playersCount:
//           return b.playersCount.compareTo(a.playersCount);
//         case SortBy.questionsCount:
//           return b.questionsCount.compareTo(a.questionsCount);
//         case SortBy.timePerQuestion:
//           return b.timePerQuestion.compareTo(a.timePerQuestion);
//         default:
//           return 0; // No sorting if 'nothing' is selected
//       }
//     });
//     return _filtersProvider.isReversedSort
//         ? sortedRooms.reversed.toList()
//         : sortedRooms;
//   }
//
//   void addRoom(Room room) {
//     _rooms.add(room);
//     filterRooms();
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     _filtersProvider.removeListener(_onFiltersChanged);
//     super.dispose();
//   }
//
//   void reset() {
//     _rooms.clear();
//     _filteredRooms.clear();
//   }
// }
