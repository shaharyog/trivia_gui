import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/consts.dart';
import '../../../src/rust/api/request/get_room_players.dart';
import '../../../utils/common_functionalities/user_data_validation.dart';

Widget buildTopThreePlayer(
    {required BuildContext context,
    required Player? user,
    required double containerRatio,
    required Color containerColor,
    required Color placeColor,
    required BorderRadiusGeometry? containerBorderRadius}) {
  return LayoutBuilder(builder: (context, constraints) {
    double height = constraints.maxHeight;
    height = height > 500 ? 500 : height;
    final double width = height / 1.8 > constraints.maxWidth
        ? constraints.maxWidth
        : height / 1.8;
    double containerHeight = height * containerRatio;
    final double avatarRadius = width / 4;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: height,
          width: width,
        ),
        Positioned(
          bottom: 0,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: containerHeight,
              width: width,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: containerBorderRadius,
              ),
              child: user == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.no_accounts_outlined,
                            size: avatarRadius,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                          Text(
                            'No one yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: width / 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6)),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            user.username,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: width / 8,
                                ),
                            overflow: Skeletonizer.of(context).enabled ? TextOverflow.clip : TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Skeleton.unite(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${user.score}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: placeColor,
                                        fontSize: width / 10,
                                      ),
                                  overflow: Skeletonizer.of(context).enabled ? TextOverflow.clip : TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Icon(
                                  Icons.star_border_sharp,
                                  size: width / 8,
                                  color: placeColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (user != null)
          Positioned(
            bottom: containerHeight - avatarRadius / 1.5,
            child: Skeleton.shade(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: placeColor,
                    width: width / 40,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor:
                      avatarColorsMap[user.avatarColor] ?? Colors.blue,
                  radius: avatarRadius,
                  child: Text(
                    getInitials(user.username),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: avatarRadius,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  });
}
