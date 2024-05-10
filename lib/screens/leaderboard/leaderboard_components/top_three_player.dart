import 'package:flutter/material.dart';
import 'package:trivia/Objects/user_score.dart';

Widget buildTopThreePlayer(
    {required BuildContext context,
    required UserScore? user,
    required double avatarRadius,
    required double containerRatio,
    required Color containerColor,
    required Color placeColor,
    required BorderRadiusGeometry? containerBorderRadius}) {
  double height = (MediaQuery.of(context).size.height - 32) / 3;
  height = height > 300 ? 300 : height;
  double containerHeight = height * containerRatio;

  return Column(
    children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: height,
            width: (MediaQuery.of(context).size.width - 32) / 3,
          ),
          Positioned(
            top: containerRatio,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: containerHeight,
                width: (MediaQuery.of(context).size.width - 32) / 3,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: containerBorderRadius,
                ),
                child: user == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_accounts_outlined,
                              size: 32,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6)),
                          Text(
                            'No one yet',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6)),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${user.score}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: placeColor,
                                    ),
                              ),
                              Icon(Icons.star_border_sharp, size: 22, color: placeColor),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
          user == null
              ? Container()
              : Positioned(
                  top: containerRatio - avatarRadius - 5,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: placeColor,
                        width: 3.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: user.avatarColor,
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
  if (name.isEmpty) return '';
  List<String> words = name.split(' ');
  String initials = '';
  for (var word in words) {
    if (initials.length < 2) {
      initials += word[0].toUpperCase();
    }
  }
  return initials;
}
