import 'package:flutter/material.dart';

enum ScreenSize { small, medium, large }

class ScreenSizeProvider with ChangeNotifier {
  ScreenSize _screenSize = ScreenSize.medium;

  ScreenSize get screenSize => _screenSize;


  void setScreenSize(double screenWidth) {
    if (screenWidth >= 1350) {
      _screenSize = ScreenSize.large;
    } else if (screenWidth >= 500) {
      _screenSize = ScreenSize.medium;
    } else {
      _screenSize = ScreenSize.small;
    }
    notifyListeners();
  }
}
