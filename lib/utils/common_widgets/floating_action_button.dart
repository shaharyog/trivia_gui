import 'package:flutter/material.dart';
import 'package:side_sheet_material3/side_sheet_material3.dart';
import '../../screens/rooms/create_room_sheet/create_room_adaptive_sheet.dart';
import '../../src/rust/api/request/create_room.dart';
import '../../src/rust/api/session.dart';
import '../common_functionalities/screen_size.dart';

class HomePageFloatingActionButton extends StatelessWidget {
  final int navigationIndex;
  final Session session;

  const HomePageFloatingActionButton({
    super.key,
    required this.navigationIndex,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (getScreenSize(context) == ScreenSize.small) {
          await showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            context: context,
            builder: (context) => CreateRoomAdaptiveSheet(
              onSave: save,
              isSideSheet: false,
            ),
          );
        } else {
          await showModalSideSheet(
            addActions: false,
            addBackIconButton: false,
            addDivider: false,
            addCloseIconButton: false,
            barrierDismissible: true,
            context,
            body: CreateRoomAdaptiveSheet(
              onSave: save,
              isSideSheet: true,
            ),
            header: 'Create Room',
          );
        }
      },
      child: const Icon(Icons.add),
    );
  }

  Future<void> save(String name, int maxPlayers, int questionCount,
      int timePerQuestion) async {
    return await session.createRoom(
      roomData: RoomData(
        name: name,
        maxPlayers: maxPlayers,
        questionCount: questionCount,
        timePerQuestion: timePerQuestion,
      ),
    );
  }
}
