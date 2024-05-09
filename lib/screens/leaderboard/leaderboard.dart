import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/screens/leaderboard/leaderboard_components/top_three.dart';
import '../../Objects/user_score.dart';
import '../../providers/leaderboard_provider.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
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

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: leaderboardProvider.topUsers.isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: _buildTopThree(
                    topUsers: leaderboardProvider.topUsers,
                    context: context,
                  ),
                ),
                if (leaderboardProvider.topUsers.length > 3) Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.069),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: ListView.separated(
                      itemCount: leaderboardProvider.topUsers.length - 3,
                      itemBuilder: (context, index) {
                        final user = leaderboardProvider.topUsers[index + 3];
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
                  ),
                ),
              ],
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
            ),
    );
  }
}

Widget _buildTopThree({
  required BuildContext context,
  required List<UserScore> topUsers,
}) {
  UserScore? user1 = topUsers.isNotEmpty ? topUsers[0] :
    null;
  UserScore? user2 = topUsers.length > 1 ? topUsers[1] : null;
  UserScore? user3 = topUsers.length > 2 ? topUsers[2] : null;

  return TopThree(
    user1: user1,
    user2: user2,
    user3: user3,
  );
}
