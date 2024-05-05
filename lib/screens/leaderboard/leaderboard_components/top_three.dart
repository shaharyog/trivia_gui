import 'package:flutter/material.dart';
import 'package:trivia/Objects/user_score.dart';
import 'package:trivia/screens/leaderboard/leaderboard_components/top_three_player.dart';

class TopThree extends StatelessWidget {
  final UserScore user1, user2, user3;

  const TopThree(
      {super.key,
      required this.user1,
      required this.user2,
      required this.user3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTopThreePlayer(
          context: context,
          user: user2,
          avatarRadius: 27.5,
          containerSize: 120,
          containerColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.08),
          avatarBorderColor: const Color.fromRGBO(179, 179, 179, 1),
          scoreTextColor: const Color.fromRGBO(156, 156, 156, 1.0),
          containerBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        buildTopThreePlayer(
          context: context,
          user: user1,
          avatarRadius: 30,
          containerSize: 150,
          containerColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.12),
          scoreTextColor: const Color.fromRGBO(206, 151, 3, 1.0),
          avatarBorderColor: const Color.fromRGBO(217, 158, 3, 1.0),
          containerBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        buildTopThreePlayer(
          context: context,
          user: user3,
          avatarRadius: 25,
          containerSize: 105,
          containerColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.08),
          scoreTextColor: const Color.fromRGBO(208, 125, 43, 1.0),
          avatarBorderColor: const Color.fromRGBO(205, 127, 50, 1.0),
          containerBorderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Stack(
        //       alignment: Alignment.topCenter,
        //       children: [
        //         const SizedBox(
        //           height: 180,
        //           width: 120,
        //         ),
        //         Positioned(
        //           top: 70,
        //           child: Container(
        //             height: 110,
        //             width: 120,
        //             decoration: BoxDecoration(
        //               color: Theme.of(context)
        //                   .colorScheme
        //                   .primary
        //                   .withOpacity(0.025),
        //               borderRadius: const BorderRadius.only(
        //                 topLeft: Radius.circular(16),
        //                 bottomLeft: Radius.circular(16),
        //               ),
        //             ),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   user2.name,
        //                   style: Theme.of(context).textTheme.titleMedium,
        //                 ),
        //                 Text(
        //                   '${user2.score}',
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .titleSmall!
        //                       .copyWith(
        //                           color: const Color.fromRGBO(156, 156, 156, 1.0),
        //                           fontWeight: FontWeight.bold),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Positioned(
        //           top: 35,
        //           child: Container(
        //             decoration: BoxDecoration(
        //               shape: BoxShape.circle,
        //               border: Border.all(
        //                 color: const Color.fromRGBO(179, 179, 179, 1),
        //                 width: 2.0,
        //               ),
        //             ),
        //             child: CircleAvatar(
        //               backgroundColor: brightness == Brightness.dark
        //                   ? Colors.grey[700]
        //                   : Colors.grey[300],
        //               radius: 27.5,
        //               child: Text(
        //                 getInitials(user2.name),
        //                 style: Theme.of(context).textTheme.titleLarge,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Stack(
        //       alignment: Alignment.topCenter,
        //       children: [
        //         const SizedBox(
        //           height: 180,
        //           width: 120,
        //         ),
        //         Positioned(
        //           top: 35,
        //           child: Container(
        //             height: 145,
        //             width: 120,
        //             decoration: BoxDecoration(
        //               color: Theme.of(context)
        //                   .colorScheme
        //                   .primary
        //                   .withOpacity(0.03),
        //               borderRadius: const BorderRadius.only(
        //                 topLeft: Radius.circular(32),
        //                 topRight: Radius.circular(32),
        //               ),
        //             ),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   user1.name,
        //                   style: Theme.of(context).textTheme.titleMedium,
        //                 ),
        //                 Text(
        //                   '${user1.score}',
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .titleSmall!
        //                       .copyWith(
        //                       color: const Color.fromRGBO(183, 119, 2, 1.0),
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Container(
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             border: Border.all(
        //               color: const Color.fromRGBO(206, 151, 3, 1.0),
        //               width: 2.0,
        //             ),
        //           ),
        //           child: CircleAvatar(
        //             backgroundColor: brightness == Brightness.dark
        //                 ? Colors.grey[700]
        //                 : Colors.grey[300],
        //             radius: 30,
        //             child: Text(
        //               getInitials(user1.name),
        //               style: Theme.of(context).textTheme.titleLarge,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Stack(
        //       alignment: Alignment.topCenter,
        //       children: [
        //         const SizedBox(
        //           height: 180,
        //           width: 120,
        //         ),
        //         Positioned(
        //           top: 90,
        //           child: Container(
        //             height: 90,
        //             width: 120,
        //             decoration: BoxDecoration(
        //               color: Theme.of(context)
        //                   .colorScheme
        //                   .primary
        //                   .withOpacity(0.025),
        //               borderRadius: const BorderRadius.only(
        //                 topRight: Radius.circular(16),
        //                 bottomRight: Radius.circular(16),
        //               ),
        //             ),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   user3.name,
        //                   style: Theme.of(context).textTheme.titleMedium,
        //                 ),
        //                 Text(
        //                   '${user3.score}',
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .titleSmall!
        //                       .copyWith(
        //                       color: const Color.fromRGBO(208, 125, 43, 1.0),
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Positioned(
        //           top: 55,
        //           child: Container(
        //             decoration: BoxDecoration(
        //               shape: BoxShape.circle,
        //               border: Border.all(
        //                 color: const Color.fromRGBO(205, 127, 50, 1.0),
        //                 width: 2.0,
        //               ),
        //             ),
        //             child: CircleAvatar(
        //               backgroundColor: brightness == Brightness.dark
        //                   ? Colors.grey[700]
        //                   : Colors.grey[300],
        //               radius: 25,
        //               child: Text(
        //                 getInitials(user3.name),
        //                 style: Theme.of(context).textTheme.titleLarge,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
