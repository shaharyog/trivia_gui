import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/utils/common_functionalities/screen_size.dart';
import 'package:trivia/utils/common_functionalities/seconds_to_readable.dart';

import '../../../consts.dart';
import '../../../src/rust/api/request/get_rooms.dart';
import '../../../utils/common_functionalities/user_data_validation.dart';
import '../../../utils/common_widgets/gradient_text.dart';

class RoomDetailsContents extends StatefulWidget {
  final Room room;
  final bool isBottomSheet;
  final Function? onSwitchToLargeScreen;
  final String username;

  const RoomDetailsContents({
    super.key,
    required this.room,
    this.isBottomSheet = false,
    this.onSwitchToLargeScreen,
    required this.username,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Skeleton.replace(
                  replacement: Text(
                    widget.room.roomData.name,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  child: AnimatedGradientText(
                    widget.room.roomData.name,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
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
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text.rich(TextSpan(
                  text: "Question count: ${widget.room.roomData.questionCount}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: const Color(0xffD2BEFF)),
                  children: [
                    TextSpan(
                      text: "   •   ",
                      style: Theme.of(context).textTheme.titleMedium,
                      // gradient of the two colors
                    ),
                    TextSpan(
                      text:
                          "Time per question: ${secondsToReadableTime(widget.room.roomData.timePerQuestion)}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: const Color(0xff90b4fa)),
                    )
                  ],
                )),
              ),
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  widget.room.isFinished
                      ? "Game has ended..."
                      : widget.room.isActive
                          ? "Game is running..."
                          : widget.room.players.length > 1
                              ? "Game is waiting to start..."
                              : "Waiting for players...",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text.rich(
                TextSpan(
                  text: "List of players: ",
                  style: Theme.of(context).textTheme.titleLarge,
                  children: [
                    TextSpan(
                      text:
                          "(${widget.room.players.length}/${widget.room.roomData.maxPlayers})",
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
              ),
            ),
            // players list
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.room.players.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.room.players.length) {
                  return const SizedBox(
                    height: 84,
                  );
                }

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: Skeleton.shade(
                    child: CircleAvatar(
                      backgroundColor: avatarColorsMap[
                              widget.room.players[index].avatarColor] ??
                          Colors.blue,
                      radius: 20,
                      child: Text(
                        getInitials(widget.room.players[index].username),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: (index == 0 &&
                            !widget.room
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
                                  "Admin${widget.username == widget.room.players[index].username ? '/You' : ''}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          )
                        : ClipRect(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person_sharp,
                                  // size: 16,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Member${widget.username == widget.room.players[index].username ? '/You' : ''}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                  ),
                  title: Text(
                    widget.room.players[index].username,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: (index == widget.room.players.length - 1)
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                  ),
                  subtitle: ClipRect(
                    child: Skeleton.unite(
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
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                if (index == widget.room.players.length - 1) {
                  return const SizedBox.shrink();
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
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
