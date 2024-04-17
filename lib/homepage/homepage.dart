import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/screen_size_provider.dart';
import 'homepage_large.dart';
import 'homepage_medium.dart';
import 'homepage_small.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenSizeProvider>(
      builder: (context, screenSizeProvider, _) {
        final screenWidth = MediaQuery.of(context).size.width;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          screenSizeProvider.setScreenSize(screenWidth);
        });

        Widget homePage;

        switch (screenSizeProvider.screenSize) {
          case ScreenSize.large:
            homePage = const HomePageLarge();
            break;
          case ScreenSize.medium:
            homePage = const HomePageMedium();
            break;
          case ScreenSize.small:
          default:
            homePage = const HomePageSmall();
            break;
        }

        return homePage;
      },
    );
  }
}
