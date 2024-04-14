import 'package:flutter/material.dart';

import 'homepage_large.dart';
import 'homepage_mid_small.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1350) {
        return HomePageLarge();
      } else {
        return HomePageMediumOrSmall();
      }
    });
  }
}
