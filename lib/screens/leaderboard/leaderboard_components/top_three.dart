import 'package:flutter/material.dart';
import 'package:trivia/screens/leaderboard/leaderboard_components/top_three_player.dart';

import '../../../src/rust/api/request/get_room_players.dart';

class TopThree extends StatelessWidget {
  final Player? user1, user2, user3;

  const TopThree(
      {super.key,
      required this.user1,
      required this.user2,
      required this.user3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: buildTopThreePlayer(
            context: context,
            user: user2,
            containerRatio: 0.65,
            containerColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
            placeColor: const Color.fromRGBO(183, 177, 177, 1.0),
            containerBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
        ),
        Flexible(
          child: buildTopThreePlayer(
            context: context,
            user: user1,
            containerRatio: 0.78,
            containerColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.25),
            placeColor: const Color.fromRGBO(239, 179, 15, 1.0),
            containerBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
        ),
        Flexible(
          child: buildTopThreePlayer(
            context: context,
            user: user3,
            containerRatio: 0.5,
            containerColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
            placeColor: const Color.fromRGBO(173, 91, 11, 1.0),
            containerBorderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
