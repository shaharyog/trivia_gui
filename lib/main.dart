import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'consts.dart';
import 'homepage/homepage.dart';
import 'auth/login.dart';
import 'providers/navigation_provider.dart';
import 'auth/signup.dart';
import 'package:provider/provider.dart';
import 'providers/filters_providers/rooms_filters_provider.dart';
import 'providers/rooms_provider.dart';
import 'providers/screen_size_provider.dart';
import 'providers/server_endpoint_provider.dart';
import 'providers/theme_provider.dart';

const _defaultLightColorScheme = ColorScheme.light();

const _defaultDarkColorScheme = ColorScheme.dark();

void main() async {
  // check if the platform is windows, linux or mac
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: initialScreenSize,
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.setMinimumSize(minScreenSize);
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NavigationState()),
        ChangeNotifierProvider(create: (context) => FiltersProvider()),
        ChangeNotifierProvider(create: (context) => ScreenSizeProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                RoomsProvider(context.read<FiltersProvider>())),
        ChangeNotifierProvider(create: (context) => ServerEndpointProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return DynamicColorBuilder(
          builder: (lightColorScheme, darkColorScheme) => MaterialApp(
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
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
              '/home': (context) => const Homepage(),
            },
          ),
        );
      },
    );
  }
}
