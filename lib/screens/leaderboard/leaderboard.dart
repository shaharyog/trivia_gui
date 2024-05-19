import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/screens/leaderboard/leaderboard_components/top_three.dart';
import '../../objects/user_score.dart';
import '../../providers/leaderboard_provider.dart';
import '../../src/rust/api/session.dart';
import '../../utils/common_functionalities/screen_size.dart';
import '../../utils/common_functionalities/user_data_validation.dart';

class Leaderboard extends StatefulWidget {
  final Session session;
  const Leaderboard({super.key, required this.session});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);

    return leaderboardProvider.topUsers.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: getScreenSize(context) == ScreenSize.small
                ? _buildSmallScreen(context, leaderboardProvider.topUsers)
                : _buildLargeScreen(context, leaderboardProvider.topUsers),
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
  required List<UserScore> topUsers,
}) {
  UserScore? user1 = topUsers.isNotEmpty ? topUsers[0] : null;
  UserScore? user2 = topUsers.length > 1 ? topUsers[1] : null;
  UserScore? user3 = topUsers.length > 2 ? topUsers[2] : null;

  return TopThree(
    user1: user1,
    user2: user2,
    user3: user3,
  );
}

Widget _buildSmallScreen(BuildContext context, List<UserScore> topUsers) {
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

Widget _buildLargeScreen(BuildContext context, List<UserScore> topUsers) {
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
    required List<UserScore> topUsers,
    required int startIndex}) {
  return Container(
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
          leading: CircleAvatar(
            backgroundColor: user.avatarColor,
            child: Text(
              getInitials(user.name),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          trailing: Text(
            "#${index + startIndex + 1}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          title: Text(
            user.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: ClipRect(
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
