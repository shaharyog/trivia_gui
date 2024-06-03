import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../src/rust/api/request/get_rooms.dart';
import '../../../utils/common_functionalities/seconds_to_readable.dart';
import 'blinking_circle.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final AnimationController blinkingController;
  final ValueChanged<String>? onRoomSelected;
  final String? selectedRoomId;
  final Function(String, String) onRoomJoin;

  const RoomCard({
    super.key,
    required this.room,
    required this.blinkingController,
    this.onRoomSelected,
    this.selectedRoomId,
    required this.onRoomJoin,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.25),
      tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onTap: () {
        onRoomSelected?.call(room.id);
      },
      selected: room.id == selectedRoomId,
      title: Text(
        room.roomData.name,
        overflow: TextOverflow.ellipsis,
      ),
      leading: roomLeadingStatus(
        context: context,
        room: room,
        blinkingController: blinkingController,
      ),
      subtitle: roomSubtitleInfo(context: context, room: room),
      trailing: IconButton(
        onPressed: room.isActive || room.players.length >= room.roomData.maxPlayers
            ? null
            : () {
                onRoomJoin(room.id, room.roomData.name);
              },
        icon: const Icon(
          Icons.login_sharp,
        ),
      ),
    );
  }
}

Widget roomSubtitleInfo({required BuildContext context, required Room room}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Skeleton.unite(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.group_sharp,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text('${room.players.length}/${room.roomData.maxPlayers}'),
          const SizedBox(
            width: 12,
          ),
          const Icon(
            Icons.question_mark_sharp,
            size: 16,
          ),
          const SizedBox(width: 2),
          Text('${room.roomData.questionCount}'),
          const SizedBox(
            width: 12,
          ),
          const Icon(
            Icons.timer_sharp,
            size: 16,
          ),
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
