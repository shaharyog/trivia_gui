import 'package:flutter/material.dart';
import 'package:your_flutter_app_name/homepage/homepage_small.dart';

import 'homepage_large.dart';
import 'homepage_medium.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1350) {
        return HomePageLarge();
      } else if (constraints.maxWidth >= 600) {
        return HomePageMedium();
      } else {
        return HomePageSmall();
      }
    });
  }
}
