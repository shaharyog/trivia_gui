import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

Widget themeToggleButton(BuildContext context) {
  return Hero(
    tag: "themeToggle",
    child: IconButton(
      icon: Icon(
        Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.light
            ? Icons.brightness_2_sharp
            : Icons.brightness_6_sharp,
      ),
      onPressed: () {
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
    ),
  );
}
