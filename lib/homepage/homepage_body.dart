import 'package:flutter/material.dart';
import 'package:trivia/screens/profile/profile.dart';
import '../providers/filters_providers/filters.dart';
import '../screens/leaderboard/leaderboard.dart';
import '../screens/rooms/rooms.dart';
import '../src/rust/api/session.dart';

class HomePageBody extends StatelessWidget {
  final int navigationIndex;
  final Session session;
  final Filters filters;
  final ValueChanged<Filters> onFiltersChanged;

  const HomePageBody({
    super.key,
    required this.navigationIndex,
    required this.session,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (navigationIndex) {
      case 0:
        return Leaderboard(session: session);
      case 1:
        return RoomsWidget(
          session: session,
          filters: filters,
          onFiltersChanged: onFiltersChanged,
        );
      case 2:
        return ProfilePage(session: session);
      default:
        return const Text('Unknown');
    }
  }
}
