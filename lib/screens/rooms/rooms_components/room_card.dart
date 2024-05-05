import 'package:flutter/material.dart';
import '../../../Objects/room.dart';
import '../../../utils/seconds_to_readable.dart';
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
      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      child: ListTile(
        title: Text(
          room.name,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        leading: roomLeadingStatus(
            room: room, blinkingController: blinkingController),
        subtitle: roomSubtitleInfo(room: room),
        trailing: IconButton(
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
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.group_sharp, size: 16),
        const SizedBox(width: 4),
        SizedBox(
          width: 36,
          child: Text('${room.maxPlayers}'),
        ),
        const Icon(Icons.question_mark_sharp, size: 16),
        const SizedBox(width: 2),
        SizedBox(
          width: 36,
          child: Text('${room.questionsCount}'),
        ),
        const Icon(Icons.groups_sharp, size: 16),
        const SizedBox(width: 4),
        SizedBox(
          width: 36,
          child: Text(room.playersCount.toString()),
        ),
        const Icon(Icons.timer_sharp, size: 16),
        const SizedBox(width: 4),
        Text(secondsToReadableTime(room.timePerQuestion)),
      ],
    ),
  );
}

Widget roomLeadingStatus(
    {required Room room, required AnimationController blinkingController}) {
  return Padding(
    padding: const EdgeInsets.only(left: 4.0),
    child: room.isActive
        ? BlinkingCircle(animationController: blinkingController)
        : Container(
            width: 12.0,
            height: 12.0,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
  );
}
