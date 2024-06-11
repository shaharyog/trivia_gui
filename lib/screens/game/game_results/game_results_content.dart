import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/game/game_results/game_overview.dart';
import 'package:trivia/utils/common_functionalities/seconds_to_readable.dart';

import '../../../consts.dart';
import '../../../src/rust/api/request/get_game_results.dart';
import '../../../src/rust/api/session.dart';
import '../../../utils/common_functionalities/user_data_validation.dart';
import '../../../utils/common_widgets/gradient_text.dart';

class GameResultsContent extends StatelessWidget {
  final List<PlayerResult> playersResults;
  final Session session;
  final String username;
  final String gameName;
  final List<QuestionAnswered> questionsHistory;

  @override
  const GameResultsContent({super.key,
    required this.playersResults,
    required this.username,
    required this.gameName,
    required this.session, required this.questionsHistory});

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
                    gameName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  child: AnimatedGradientText(
                    gameName,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Players results: ",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
            ),
            // players list
            ListView.separated(
              shrinkWrap: true,
              itemCount: playersResults.length + 1,
              itemBuilder: (context, index) {
                if (index == playersResults.length) {
                  return const SizedBox(
                    height: 84,
                  );
                }

                return ListTile(
                  onTap: playersResults[index].player.username != username
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GameOverview(
                              username: username,
                              session: session,
                              questionsHistory: questionsHistory,
                            ),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: Skeleton.shade(
                    child: CircleAvatar(
                      backgroundColor: avatarColorsMap[
                      playersResults[index].player.avatarColor] ??
                          Colors.blue,
                      radius: 20,
                      child: Text(
                        getInitials(playersResults[index].player.username),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
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
                        children: [
                          getScoreIcon(index),
                          if (playersResults[index].scoreChange != 0)
                            Text(
                              playersResults[index].scoreChange.toString(),
                              style: TextStyle(
                                color: playersResults[index].scoreChange > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            )
                        ],
                      ),

                      // score
                      if (username == playersResults[index].player.username)
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
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (username != playersResults[index].player.username)
                        SizedBox(
                          width: 48,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Skeleton.shade(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  decoration: BoxDecoration(
                                    color: playersResults[index].isOnline
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  title: Text(
                    playersResults[index].player.username,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      fontWeight: (index == playersResults.length - 1)
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: ClipRect(
                    child: Skeleton.unite(
                      child: Row(
                        children: [
                          Text(
                            playersResults[index].player.score.toString(),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.star_border_sharp,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(secondsToReadableTime(
                              playersResults[index].avgAnswerTime)),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.timer_sharp,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(playersResults[index]
                              .correctAnswerCount
                              .toString()),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.check_sharp,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(playersResults[index]
                              .wrongAnswerCount
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
                if (index == playersResults.length - 1) {
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
    if (playersResults[index].scoreChange > 200) {
      return const Icon(
        Icons.keyboard_double_arrow_up_sharp,
        color: Colors.green,
      );
    }
    if (playersResults[index].scoreChange > 0) {
      return const Icon(
        Icons.arrow_upward_sharp,
        color: Colors.green,
      );
    } else if (playersResults[index].scoreChange < -150) {
      return const Icon(
        Icons.keyboard_double_arrow_down_sharp,
        color: Colors.red,
      );
    } else if (playersResults[index].scoreChange < 0) {
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
