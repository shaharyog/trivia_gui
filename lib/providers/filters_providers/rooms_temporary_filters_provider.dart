import 'package:flutter/material.dart';

class TemporaryFiltersProvider with ChangeNotifier {
  RangeValues _questionCountRange;
  RangeValues _playersCountRange;
  bool _isActive;

  TemporaryFiltersProvider(this._questionCountRange, this._playersCountRange, this._isActive);

  RangeValues get questionCountRange => _questionCountRange;

  RangeValues get playersCountRange => _playersCountRange;

  bool get isActive => _isActive;

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

  void reset() {
    _questionCountRange = RangeValues(0, 100);
    _playersCountRange = RangeValues(0, 10);
    _isActive = false;
    notifyListeners();
  }
}
