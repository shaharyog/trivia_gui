import 'package:flutter/material.dart';
import '../rooms_provider.dart';
import 'filters.dart';

class FiltersProvider with ChangeNotifier {
  Filters _filters = Filters();

  Filters get filters => _filters;

  SortBy get sortBy => _filters.sortBy;

  bool get isReversedSort => _filters.isReversedSort;

  bool get putActiveRoomsFirst => _filters.putActiveRoomsFirst;

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

  void setPutActiveRoomsFirst(bool putActiveRoomsFirst) {
    _filters.putActiveRoomsFirst = putActiveRoomsFirst;
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

  bool doesSorting() {
    return sortBy != SortBy.nothing;
  }

  bool doesFiltering() {
    return questionCountRange.start != 0 ||
        questionCountRange.end != 100 ||
        playersCountRange.start != 0 ||
        playersCountRange.end != 50 ||
        showOnlyActive ||
        putActiveRoomsFirst;
  }
}
