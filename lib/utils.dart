import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';

Widget makeInput({label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: 600, // Set the width of the TextField
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
          ),
        ),
      ),
      SizedBox(height: 30),
    ],
  );
}

Widget themeToggleButton() {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return IconButton(
        icon: Icon(themeProvider.themeMode == ThemeMode.light
            ? Icons.brightness_2
            : Icons.brightness_6),
        onPressed: () {
          themeProvider.toggleTheme();
        },
      );
    },
  );
}
