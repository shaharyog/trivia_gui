import 'package:flutter/material.dart';
import 'package:trivia/screens/rooms/rooms_components/room_card.dart';

import '../../src/rust/api/request/get_rooms.dart';

class RoomList extends StatelessWidget {
  final List<Room> rooms;
  final AnimationController blinkingController;

  const RoomList({
    super.key,
    required this.rooms,
    required this.blinkingController,
  });

  @override
  Widget build(BuildContext context) {
    return rooms.isNotEmpty
        ? ListView.builder(
            itemCount: rooms.length + 1,
            itemBuilder: (context, index) {
              if (index >= rooms.length) {
                return const SizedBox(
                  height: 84,
                );
              }
              final room = rooms[index];
              return RoomCard(
                room: room,
                blinkingController: blinkingController,
              );
            },
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.do_not_disturb,
                size: 64,
              ),
              Text("No available rooms found",
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          );
  }
}
