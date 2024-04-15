import 'package:flutter/material.dart';

import 'rooms_temporary_filters_provider.dart';

class FiltersProvider with ChangeNotifier {
  String _searchText = '';
  RangeValues _questionCountRange = RangeValues(0, 100);
  RangeValues _playersCountRange = RangeValues(0, 10);
  bool _isActive = false;

  String get searchText => _searchText;

  RangeValues get questionCountRange => _questionCountRange;

  RangeValues get playersCountRange => _playersCountRange;

  bool get isActive => _isActive;

  void updateSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void updateQuestionCountRange(RangeValues range) {
    _questionCountRange = range;
    notifyListeners();
  }

  void updatePlayersCountRange(RangeValues range) {
    _playersCountRange = range;
    notifyListeners();
  }

  void updateIsActive(bool isActive) {
    _isActive = isActive;
    notifyListeners();
  }

  // Method to apply filters from the temporary filters
  void applyTemporaryFilters(
      TemporaryFiltersProvider temporaryFiltersProvider) {
    _questionCountRange = temporaryFiltersProvider.questionCountRange;
    _playersCountRange = temporaryFiltersProvider.playersCountRange;
    _isActive = temporaryFiltersProvider.isActive;
    notifyListeners();
  }

  TemporaryFiltersProvider get temporaryFiltersProvider =>
      TemporaryFiltersProvider(
        _questionCountRange,
        _playersCountRange,
        _isActive,
      );
}
