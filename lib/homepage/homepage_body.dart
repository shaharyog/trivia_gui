import 'package:flutter/material.dart';
import 'package:trivia/screens/profile/profile.dart';
import '../utils/filters.dart';
import '../screens/leaderboard/leaderboard.dart';
import '../screens/rooms/rooms.dart';
import '../src/rust/api/session.dart';

class HomePageBody extends StatelessWidget {
  final int navigationIndex;
  final Session session;
  final Filters filters;
  final bool isInCreateRoomSheet;
  final String username;

  const HomePageBody({
    super.key,
    required this.navigationIndex,
    required this.session,
    required this.filters,
    required this.isInCreateRoomSheet,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    switch (navigationIndex) {
      case 0:
        return Leaderboard(session: session);
      case 1:
        return RoomsWidget(
          username: username,
          session: session,
          filters: filters,
          isInCreateRoomSheet: isInCreateRoomSheet,
        );
      case 2:
        return ProfilePage(session: session);
      default:
        return const Text('Unknown');
    }
  }
}
