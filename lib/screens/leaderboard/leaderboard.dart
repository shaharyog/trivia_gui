import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/screens/leaderboard/leaderboard_components/top_three.dart';
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
    final brightness = Theme.of(context).brightness;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0,),
              child: TopThree(
                user1: leaderboardProvider.topUsers[0],
                user2: leaderboardProvider.topUsers[1],
                user3: leaderboardProvider.topUsers[2],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.069),
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: leaderboardProvider.topUsers.length - 3,
                itemBuilder: (context, index) {
                  final user = leaderboardProvider.topUsers[index + 3];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: brightness == Brightness.dark
                          ? Colors.grey[700]
                          : Colors.grey[300],
                      child: Text(
                        getInitials(user.name),
                      ),
                    ),
                    trailing: Text("#${index + 4}",
                        style: Theme.of(context).textTheme.titleLarge),
                    title: Text(user.name),
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
          ],
        ),
      ),
    );
  }
}
