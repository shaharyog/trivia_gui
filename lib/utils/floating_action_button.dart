import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet_material3/side_sheet_material3.dart';
import '../Objects/room.dart';
import '../providers/navigation_provider.dart';
import '../providers/rooms_provider.dart';
import '../providers/screen_size_provider.dart';
import '../screens/rooms/create_room_sheet_bottom/create_room_bottom_sheet.dart';
import '../screens/rooms/create_room_sheet_bottom/create_room_side_sheet.dart';

FloatingActionButton? homePageFloatingActionButton(
    {required NavigationState navigationState, required BuildContext context}) {
  final roomsProvider = Provider.of<RoomsProvider>(context, listen: false);
  return navigationState.selectedIndex == 1
      ? FloatingActionButton(
          onPressed: () async {
            final screenSizeProvider =
                Provider.of<ScreenSizeProvider>(context, listen: false);
            String name = '';
            int maxPlayers = 2;
            int questionsCount = 2;
            int timePerQuestion = 2;
            bool isConfirmed = false;

            if (screenSizeProvider.screenSize == ScreenSize.small) {
              await showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                builder: (context) => CreateRoomBottomSheet(
                  roomNameCallback: (String value) {
                    name = value;
                  },
                  roomMaxPlayersCallback: (int value) {
                    maxPlayers = value;
                  },
                  roomQuestionsCountCallback: (int value) {
                    questionsCount = value;
                  },
                  roomTimePerQuestionCallback: (int value) {
                    timePerQuestion = value;
                  },
                  isCreationConfirmed: (bool value) {
                    isConfirmed = value;
                  },
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
                body: CreateRoomSideSheet(
                  roomNameCallback: (String value) {
                    name = value;
                  },
                  roomMaxPlayersCallback: (int value) {
                    maxPlayers = value;
                  },
                  roomQuestionsCountCallback: (int value) {
                    questionsCount = value;
                  },
                  roomTimePerQuestionCallback: (int value) {
                    timePerQuestion = value;
                  },
                  isCreationConfirmed: (bool value) {
                    isConfirmed = value;
                  },
                ),
                header: 'Create Room',
              );
            }

            if (isConfirmed) {
              roomsProvider.addRoom(Room(
                uuid: "",
                name: name,
                maxPlayers: maxPlayers,
                playersCount: 0,
                questionsCount: questionsCount,
                timePerQuestion: timePerQuestion,
                isActive: true,
              ));
            }
          },
          child: const Icon(Icons.add),
        )
      : null;
}
