import 'package:flutter/material.dart';
import 'package:trivia/consts.dart';
import '../rooms_provider.dart';
import 'filters.dart';

class FiltersProvider with ChangeNotifier {
  Filters _filters = Filters();

  Filters get filters => _filters;

  SortBy get sortBy => _filters.sortBy;

  bool get isReversedSort => _filters.isReversedSort;

  String get searchText => _filters.searchText;

  RangeValues get questionCountRange => _filters.questionCountRange;

  RangeValues get playersCountRange => _filters.playersCountRange;

  bool get showOnlyActive => _filters.showOnlyActive;

  void setSortBy(SortBy sortBy) {
    _filters.sortBy = sortBy;
    notifyListeners();
  }

  void setIsReversedSort(bool isReversedSort) {
    _filters.isReversedSort = isReversedSort;
    notifyListeners();
  }

  void updateSearchText(String text) {
    _filters.searchText = text;
    notifyListeners();
  }

  void updateQuestionCountRange(RangeValues range) {
    _filters.questionCountRange = range;
    notifyListeners();
  }

  void updatePlayersCountRange(RangeValues range) {
    _filters.playersCountRange = range;
    notifyListeners();
  }

  void updateShowOnlyActive(bool isActive) {
    _filters.showOnlyActive = isActive;
    notifyListeners();
  }

  void applyTemporaryFilters(
    Filters newFilters,
  ) {
    _filters = newFilters;
    notifyListeners();
  }

  bool doesFiltering() {
    return questionCountRange.start != defaultQuestionCountRangeStart ||
        questionCountRange.end != defaultQuestionCountRangeEnd ||
        playersCountRange.start != defaultPlayersCountRangeStart ||
        playersCountRange.end != defaultPlayersCountRangeEnd ||
        showOnlyActive != defaultShowOnlyActive;
  }

  void reset() {
    _filters.reset();
    notifyListeners();
  }

  void resetFilters() {
    _filters.resetFilters();
    notifyListeners();
  }

  void resetSort() {
    _filters.resetSort();
    notifyListeners();
  }

  void resetSortDirection() {
    _filters.resetSortDirection();
    notifyListeners();
  }

  void resetSearch() {
    _filters.resetSearch();
    notifyListeners();
  }


}
