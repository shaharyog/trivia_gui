import 'package:flutter/material.dart';
import 'package:trivia/screens/rooms/rooms_components/room_card.dart';
import 'package:trivia/utils/common_functionalities/screen_size.dart';

import '../../src/rust/api/request/get_rooms.dart';

class RoomList extends StatelessWidget {
  final List<Room> rooms;
  final AnimationController blinkingController;
  final ValueChanged<String>? onRoomSelected;
  final String? selectedRoomId;
  final Function(Room) onRoomJoin;

  const RoomList({
    super.key,
    required this.rooms,
    required this.blinkingController,
    this.onRoomSelected,
    this.selectedRoomId,
    required this.onRoomJoin,
  });

  @override
  Widget build(BuildContext context) {
    return rooms.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: rooms.length + 2,
            itemBuilder: (context, index) {
              index = index - 1;
              if (index == -1) {
                return const SizedBox(
                  height: 8,
                );
              }
              if (index == rooms.length) {
                return const SizedBox(
                  height: 84,
                );
              }
              final room = rooms[index];
              return RoomCard(
                onRoomJoin: onRoomJoin,
                selectedRoomId: selectedRoomId,
                onRoomSelected: onRoomSelected,
                room: room,
                blinkingController: blinkingController,
              );
            },
          )
        : buildNoRoomsFound(context);
  }

  Widget buildNoRoomsFound(context) {
    double height;
    if (getScreenSize(context) == ScreenSize.small) {
      // screen height - (app bar, search bar, navbar)
      height = MediaQuery.of(context).size.height - 208;
    } else {
      // screen height - (search bar)
      height = MediaQuery.of(context).size.height - 72;
    }
    return SizedBox(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
