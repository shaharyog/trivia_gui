import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/screens/leaderboard/leaderboard_components/top_three.dart';
import '../../Objects/user_score.dart';
import '../../providers/leaderboard_provider.dart';
import '../../providers/screen_size_provider.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);
    final screenSizeProvider = Provider.of<ScreenSizeProvider>(context);
    return leaderboardProvider.topUsers.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: screenSizeProvider.screenSize == ScreenSize.small
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
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: _buildTopThree(
          topUsers: topUsers,
          context: context,
        ),
      ),
      if (topUsers.length > 3)
        Expanded(
          child: _buildListView(context: context, topUsers: topUsers),
        ),
    ],
  );
}

Widget _buildLargeScreen(BuildContext context, List<UserScore> topUsers) {
  return Row(children: [
    Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(201, 166, 70, 0.30196078431372547),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
    ),
    const SizedBox(width: 16.0),
    Expanded(
      flex: 3,
      child: _buildListView(context: context, topUsers: topUsers),
    )
  ]);
}

String getInitials(String name) {
  List<String> words = name.split(' ');
  String initials = '';
  for (var word in words) {
    if (initials.length < 2) {
      initials += word[0].toUpperCase();
    }
  }
  return initials;
}

Widget _buildListView(
    {required BuildContext context, required List<UserScore> topUsers}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.069),
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    child: ListView.separated(
      itemCount: topUsers.length - 3,
      itemBuilder: (context, index) {
        final user = topUsers[index + 3];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: user.avatarColor,
            child: Text(
              getInitials(user.name),
            ),
          ),
          trailing: Text(
            "#${index + 4}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          title: Text(
            user.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Row(
            children: [
              Text(user.score.toString()),
              const SizedBox(width: 2),
              const Icon(
                Icons.star_border_sharp,
                size: 16,
              ),
            ],
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
