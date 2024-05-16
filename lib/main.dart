import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:trivia/providers/leaderboard_provider.dart';
import 'package:window_size/window_size.dart' as window_size;
import 'consts.dart';
import 'homepage/homepage.dart';
import 'auth/login.dart';
import 'providers/navigation_provider.dart';
import 'auth/signup.dart';
import 'package:provider/provider.dart';
import 'providers/filters_providers/rooms_filters_provider.dart';
import 'providers/rooms_provider.dart';
import 'providers/screen_size_provider.dart';
import 'providers/session_provider.dart';
import 'providers/theme_provider.dart';
import 'package:trivia/src/rust/frb_generated.dart';

void main() async {
  await RustLib.init();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    window_size.getWindowInfo().then(
      (window) {
        final screen = window.screen;

        if (screen != null) {
          window_size.setWindowMinSize(minScreenSize);
          window_size.setWindowMaxSize(maxScreenSize);
          window_size.setWindowTitle('Trivia');
        }
      },
    );
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
        ChangeNotifierProvider(create: (context) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScreenSizeProvider>(context, listen: false)
          .setScreenSize(screenWidth);
    });
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
            '/home': (context) => const HomePage(),
          },
        );
      },
    );
  }
}
