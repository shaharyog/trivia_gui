import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/consts.dart';
import '../../src/rust/api/request/get_room_players.dart';
import '../../utils/common_functionalities/screen_size.dart';
import '../../utils/common_functionalities/user_data_validation.dart';
import 'leaderboard_components/top_three.dart';

class LeaderboardContent extends StatelessWidget {
  final List<Player> players;

  const LeaderboardContent({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return players.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: getScreenSize(context) == ScreenSize.small
                ? _buildSmallScreen(context, players)
                : _buildLargeScreen(context, players),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.do_not_disturb,
                  size: 64,
                ),
                Text(
                  "No users found",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
  }
}

Widget _buildTopThree({
  required BuildContext context,
  required List<Player> topUsers,
}) {
  Player? user1 = topUsers.isNotEmpty ? topUsers[0] : null;
  Player? user2 = topUsers.length > 1 ? topUsers[1] : null;
  Player? user3 = topUsers.length > 2 ? topUsers[2] : null;

  return TopThree(
    user1: user1,
    user2: user2,
    user3: user3,
  );
}

Widget _buildSmallScreen(BuildContext context, List<Player> topUsers) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: _buildTopThree(
              topUsers: topUsers,
              context: context,
            ),
          ),
        ),
        if (topUsers.length > 3)
          Expanded(
            flex: 3,
            child: _buildListView(
                context: context, topUsers: topUsers, startIndex: 3),
          ),
      ],
    ),
  );
}

Widget _buildLargeScreen(BuildContext context, List<Player> topUsers) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 16.0,
              right: 16.0,
            ),
            child: _buildTopThree(
              topUsers: topUsers,
              context: context,
            ),
          ),
        ),
        if (topUsers.length > 3)
          Expanded(
            flex: 2,
            child: _buildListView(
                context: context, topUsers: topUsers, startIndex: 3),
          ),
      ],
    ),
  );
}

Widget _buildListView(
    {required BuildContext context,
    required List<Player> topUsers,
    required int startIndex}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    child: ListView.separated(
      itemCount: topUsers.length - startIndex,
      itemBuilder: (context, index) {
        final user = topUsers[index + startIndex];
        return ListTile(
          leading: Skeleton.shade(
            child: CircleAvatar(
              backgroundColor: Skeletonizer.of(context).enabled ? null : avatarColorsMap[user.avatarColor] ?? Colors.blue,
              radius: 24,
              child: Text(
                getInitials(user.username),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          trailing: Text(
            "#${index + startIndex + 1}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          title: Text(
            user.username,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: ClipRect(
            child: Skeleton.unite(
              child: Row(
                children: [
                  Text(
                    user.score.toString(),
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
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        );
      },
    ),
  );
}
