import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

Widget themeToggleButton() {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return Hero(
        tag: "themeToggle",
        child: IconButton(
          icon: Icon(themeProvider.themeMode == ThemeMode.light
              ? Icons.brightness_2
              : Icons.brightness_6),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
      );
    },
  );
}