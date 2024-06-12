import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'consts.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup/signup.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'package:trivia/src/rust/frb_generated.dart';

import 'utils/common_functionalities/window_management.dart';

void main() async {
  await RustLib.init();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    await windowManager.setTitle("Trivia");
    await windowManager.setSize(defaultScreenSize);
    await windowManager.setMinimumSize(minScreenSize);
  }


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.addListener(this);  // add window listener
    }
  }

  // always enforce the minimum screen size
  // because the window manager doesn't enforce it after minimize/maximize
  @override
  void onWindowEvent(String eventName) {
    super.onWindowEvent(eventName);
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      enforceMinScreenSize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme ?? defaultLightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme ?? defaultDarkColorScheme,
          ),
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          debugShowCheckedModeBanner: false,
          title: 'Trivia',
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/signup': (context) => const SignupPage(),
          },
        );
      },
    );
  }
}
