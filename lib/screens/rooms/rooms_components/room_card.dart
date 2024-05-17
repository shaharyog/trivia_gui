import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../src/rust/api/request/get_rooms.dart';
import '../../../utils/common_functionalities/seconds_to_readable.dart';
import 'blinking_circle.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final AnimationController blinkingController;

  const RoomCard(
      {super.key, required this.room, required this.blinkingController});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.015),
      child: ListTile(
        title: Text(
          room.roomData.name,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        leading: roomLeadingStatus(
          context: context,
          room: room,
          blinkingController: blinkingController,
        ),
        subtitle: roomSubtitleInfo(room: room),
        trailing: room.isActive
            ? null
            : IconButton(
                onPressed: () {
                  // Join Room In The Future...
                },
                icon: const Icon(Icons.login_sharp),
              ),
      ),
    );
  }
}

Widget roomSubtitleInfo({required Room room}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Skeleton.unite(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.group_sharp, size: 16),
          const SizedBox(width: 4),
          Text('${room.roomData.maxPlayers}'),
          const SizedBox(
            width: 12,
          ),
          const Icon(Icons.question_mark_sharp, size: 16),
          const SizedBox(width: 2),
          Text('${room.roomData.questionCount}'),
          const SizedBox(
            width: 12,
          ),
          // const Icon(Icons.groups_sharp, size: 16),
          // const SizedBox(width: 4),
          // Text(room.playersCount.toString()),
          // const SizedBox(
          //   width: 12,
          // ),
          const Icon(Icons.timer_sharp, size: 16),
          const SizedBox(width: 4),
          Text(secondsToReadableTime(room.roomData.timePerQuestion)),
        ],
      ),
    ),
  );
}

Widget roomLeadingStatus(
    {required Room room,
    required AnimationController blinkingController,
    required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(left: 4.0),
    child: room.isActive && !Skeletonizer.of(context).enabled
        ? BlinkingCircle(animationController: blinkingController)
        : Skeleton.shade(
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
  );
}
