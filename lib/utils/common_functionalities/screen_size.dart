
import 'package:flutter/material.dart';

enum ScreenSize { small, medium, large }


ScreenSize getScreenSize(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  if (screenWidth >= 1350) {
    return ScreenSize.large;
  } else if (screenWidth >= 700) {
    return ScreenSize.medium;
  } else {
    return ScreenSize.small;
  }
}