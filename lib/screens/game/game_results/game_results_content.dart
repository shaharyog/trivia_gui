import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/game/game_results/game_overview.dart';
import 'package:trivia/screens/rooms/rooms_components/blinking_circle.dart';
import 'package:trivia/utils/common_functionalities/seconds_to_readable.dart';

import '../../../consts.dart';
import '../../../src/rust/api/request/get_game_results.dart';
import '../../../src/rust/api/session.dart';
import '../../../utils/common_functionalities/user_data_validation.dart';
import '../../../utils/common_widgets/gradient_text.dart';

class GameResultsContent extends StatefulWidget {
  final List<PlayerResult> playersResults;
  final Session session;
  final String username;
  final String gameName;
  final List<QuestionAnswered> questionsHistory;

  @override
  const GameResultsContent(
      {super.key,
      required this.playersResults,
      required this.username,
      required this.gameName,
      required this.session,
      required this.questionsHistory});

  @override
  State<GameResultsContent> createState() => _GameResultsContentState();
}

class _GameResultsContentState extends State<GameResultsContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkingController;

  @override
  void initState() {
    super.initState();
    _blinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    widget.gameName,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  child: AnimatedGradientText(
                    widget.gameName,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Players results: ",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // players list
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.playersResults.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.playersResults.length) {
                  return const SizedBox(
                    height: 84,
                  );
                }

                return ListTile(
                  onTap: widget.playersResults[index].player.username !=
                          widget.username
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameOverview(
                                username: widget.username,
                                session: widget.session,
                                questionsHistory: widget.questionsHistory,
                              ),
                            ),
                          );
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: Skeleton.shade(
                    child: CircleAvatar(
                      backgroundColor: avatarColorsMap[widget
                              .playersResults[index].player.avatarColor] ??
                          Colors.blue,
                      radius: 20,
                      child: Text(
                        getInitials(
                            widget.playersResults[index].player.username),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getScoreIcon(index),
                          if (widget.playersResults[index].scoreChange != 0)
                            Text(
                              widget.playersResults[index].scoreChange
                                  .toString(),
                              style: TextStyle(
                                color:
                                    widget.playersResults[index].scoreChange > 0
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            )
                        ],
                      ),

                      // score
                      if (widget.username ==
                          widget.playersResults[index].player.username)
                        SizedBox(
                          width: 48,
                          child: ClipRect(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person_sharp,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'You',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.username !=
                          widget.playersResults[index].player.username)
                        SizedBox(
                          width: 48,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Skeleton.shade(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 2.0),
                                  child: widget.playersResults[index].isOnline
                                      ? BlinkingCircle(
                                          animationController:
                                              _blinkingController,
                                          color: Colors.greenAccent,
                                        )
                                      : Container(
                                          width: 12.0,
                                          height: 12.0,
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  title: Text(
                    widget.playersResults[index].player.username,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight:
                              (index == widget.playersResults.length - 1)
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                        ),
                  ),
                  subtitle: ClipRect(
                    child: Skeleton.unite(
                      child: Row(
                        children: [
                          Text(
                            widget.playersResults[index].player.score
                                .toString(),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.star_border_sharp,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(secondsToReadableTime(
                              widget.playersResults[index].avgAnswerTime)),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.timer_sharp,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(widget.playersResults[index].correctAnswerCount
                              .toString()),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.check_sharp,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(widget.playersResults[index].wrongAnswerCount
                              .toString()),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.close_sharp,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                if (index == widget.playersResults.length - 1) {
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

  Widget getScoreIcon(int index) {
    if (widget.playersResults[index].scoreChange > 200) {
      return const Icon(
        Icons.keyboard_double_arrow_up_sharp,
        color: Colors.green,
      );
    }
    if (widget.playersResults[index].scoreChange > 0) {
      return const Icon(
        Icons.arrow_upward_sharp,
        color: Colors.green,
      );
    } else if (widget.playersResults[index].scoreChange < -150) {
      return const Icon(
        Icons.keyboard_double_arrow_down_sharp,
        color: Colors.red,
      );
    } else if (widget.playersResults[index].scoreChange < 0) {
      return const Icon(
        Icons.arrow_downward_sharp,
        color: Colors.red,
      );
    } else {
      return const Icon(
        Icons.remove_sharp,
        color: Colors.grey,
      );
    }
  }
}
