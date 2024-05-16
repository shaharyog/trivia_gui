import 'dart:io';
import 'package:window_size/window_size.dart' as window_size;
import 'package:flutter/material.dart';

void setPageTitle(String title) {
  if (Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    window_size.getWindowInfo().then(
          (window) {
        final screen = window.screen;

        if (screen != null) {
          window_size.setWindowTitle('Trivia - $title');
        }
      },
    );
  }
}