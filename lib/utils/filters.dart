import 'package:flutter/material.dart';
import '../consts.dart';

enum SortBy { isActive, playersCount, questionsCount, timePerQuestion }

class Filters {
  String searchText = defaultSearchText;
  RangeValues questionCountRange = const RangeValues(
      defaultQuestionCountRangeStart, defaultQuestionCountRangeEnd);
  RangeValues playersCountRange = const RangeValues(
      defaultPlayersCountRangeStart, defaultPlayersCountRangeEnd);
  bool showActiveRooms = defaultShowActive;
  bool showInactiveRooms = defaultShowInactive;
  bool showFinishedRooms = defaultShowFinished;
  SortBy sortBy = defaultSortBy;
  bool isReversedSort = defaultIsReversedSort;

  Filters();

  Filters.fromFilters(Filters other) {
    updateFrom(other);
  }

  void reset() {
    searchText = defaultSearchText;
    questionCountRange = const RangeValues(
        defaultQuestionCountRangeStart, defaultQuestionCountRangeEnd);
    playersCountRange = const RangeValues(
        defaultPlayersCountRangeStart, defaultPlayersCountRangeEnd);
    showActiveRooms = defaultShowActive;
    showInactiveRooms = defaultShowInactive;
    showFinishedRooms = defaultShowFinished;
    sortBy = defaultSortBy;
    isReversedSort = defaultIsReversedSort;
  }

  void resetFilters() {
    questionCountRange = const RangeValues(
        defaultQuestionCountRangeStart, defaultQuestionCountRangeEnd);
    playersCountRange = const RangeValues(
        defaultPlayersCountRangeStart, defaultPlayersCountRangeEnd);
    showActiveRooms = defaultShowActive;
    showInactiveRooms = defaultShowInactive;
    showFinishedRooms = defaultShowFinished;
  }

  void resetSort() {
    sortBy = defaultSortBy;
  }

  void resetSearch() {
    searchText = defaultSearchText;
  }

  bool isFiltering() {
    return showActiveRooms != defaultShowActive ||
        showInactiveRooms != defaultShowInactive ||
        showFinishedRooms != defaultShowFinished ||
        questionCountRange.start != defaultQuestionCountRangeStart ||
        questionCountRange.end != defaultQuestionCountRangeEnd ||
        playersCountRange.start != defaultPlayersCountRangeStart ||
        playersCountRange.end != defaultPlayersCountRangeEnd;
  }

  void updateFrom(Filters other) {
    searchText = other.searchText;
    questionCountRange = other.questionCountRange;
    playersCountRange = other.playersCountRange;
    showActiveRooms = other.showActiveRooms;
    showInactiveRooms = other.showInactiveRooms;
    showFinishedRooms = other.showFinishedRooms;
    sortBy = other.sortBy;
    isReversedSort = other.isReversedSort;
  }
}
