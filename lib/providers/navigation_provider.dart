import 'package:flutter/material.dart';

class NavigationState extends ChangeNotifier {
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
