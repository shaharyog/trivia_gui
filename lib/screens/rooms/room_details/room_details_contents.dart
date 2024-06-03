import 'package:flutter/material.dart';
import 'package:trivia/utils/common_functionalities/screen_size.dart';

import '../../../consts.dart';
import '../../../src/rust/api/request/get_rooms.dart';
import '../../../utils/common_functionalities/user_data_validation.dart';
import '../../../utils/common_widgets/gradient_text.dart';

class RoomDetailsContents extends StatefulWidget {
  final Room room;
  final bool isBottomSheet;
  final Function? onSwitchToLargeScreen;
  final bool showRoomData;
  const RoomDetailsContents({
    super.key,
    required this.room,
    this.isBottomSheet = false,
    this.onSwitchToLargeScreen,
    this.showRoomData = false,
  });

  @override
  State<RoomDetailsContents> createState() => _RoomDetailsContentsState();
}

class _RoomDetailsContentsState extends State<RoomDetailsContents> {
  bool isFirstNotSmallScreen = true;

  @override
  Widget build(BuildContext context) {
    if (widget.isBottomSheet &&
        isFirstNotSmallScreen &&
        getScreenSize(context) != ScreenSize.small) {
      isFirstNotSmallScreen = false;
      widget.onSwitchToLargeScreen?.call();
      Navigator.pop(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // room name
            Center(
              child: AnimatedGradientText(
                widget.room.roomData.name,
                style: Theme
                    .of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                colors: const [
                  Color(0xff9dd769),
                  Color(0xfff0a13a),
                  Color(0xffee609a),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("List of players:",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge),
            ),
            // players list
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.room.players.length,
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: CircleAvatar(
                    backgroundColor:
                    avatarColorsMap[widget.room.players[index].avatarColor] ??
                        Colors.blue,
                    radius: 20,
                    child: Text(
                      getInitials(widget.room.players[index].username),
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  trailing: (index == 0 && !widget.room
                      .isActive) // admin matters only when the room is not active
                      ? ClipRect(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.manage_accounts_sharp,
                          // size: 16,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Admin",
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall,
                        ),
                      ],
                    ),
                  )
                      : null,
                  title: Text(
                    widget.room.players[index].username,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      fontWeight: (index == widget.room.players.length - 1)
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: ClipRect(
                    child: Row(
                      children: [
                        Text(
                          widget.room.players[index].score.toString(),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.star_border_sharp,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
