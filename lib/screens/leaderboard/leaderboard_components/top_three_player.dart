

import 'package:flutter/material.dart';
import 'package:trivia/Objects/user_score.dart';

Widget buildTopThreePlayer({required BuildContext context, required UserScore user, required double avatarRadius, required double containerSize, required Color containerColor, required Color avatarBorderColor, required Color scoreTextColor, required BorderRadiusGeometry? containerBorderRadius}) {
  final brightness = Theme.of(context).brightness;
  return Column(
    children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: 185,
            width: (MediaQuery.of(context).size.width - 32) / 3,
          ),
          Positioned(
            top: 185 - containerSize,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: containerSize,
                width: (MediaQuery.of(context).size.width - 32) / 3,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: containerBorderRadius,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${user.score}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                          color: scoreTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 185 -containerSize - avatarRadius - 5,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: avatarBorderColor,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey[300],
                radius: avatarRadius,
                child: Text(
                  getInitials(user.name),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}


String getInitials(String name) {
  List<String> words = name.split(' ');
  String initials = '';
  for (var word in words) {
    if (initials.length < 2) {
      initials += word[0].toUpperCase();
    }
  }
  return initials;
}