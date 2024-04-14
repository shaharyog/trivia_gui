
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:your_flutter_app_name/theme_provider.dart';
import 'login.dart';
import 'signup.dart';
import 'package:provider/provider.dart';

const _defaultLightColorScheme = ColorScheme.light();

const _defaultDarkColorScheme = ColorScheme.dark();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return DynamicColorBuilder(
            builder: (lightColorScheme, darkColorScheme) =>
                MaterialApp(
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: lightColorScheme ?? _defaultLightColorScheme,
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
                  ),
                  themeMode: themeProvider.themeMode,
                  debugShowCheckedModeBanner: false,
                  title: 'Trivia - Shahar & Yuval',
                  initialRoute: '/login',
                  routes: {
                    // When navigating to the "/" route, build the HomePage widget.
                    '/login': (context) => LoginPage(),
                    '/signup': (context) => SignupPage(),
                  },
                )
        );
      },
    );
  }
}