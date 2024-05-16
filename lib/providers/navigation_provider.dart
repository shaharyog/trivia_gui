import 'package:flutter/material.dart';

class NavigationState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void reset() {
    _selectedIndex = 0;
    notifyListeners();
  }
}
