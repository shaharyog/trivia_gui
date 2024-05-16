import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filters_providers/rooms_filters_provider.dart';
import '../providers/leaderboard_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/rooms_provider.dart';
import '../providers/session_provider.dart';

void resetProviders(BuildContext context) {
  Provider.of<SessionProvider>(context, listen: false).reset();
  Provider.of<NavigationState>(context, listen: false).reset();
  Provider.of<FiltersProvider>(context, listen: false).reset();
  Provider.of<RoomsProvider>(context, listen: false).reset();
  Provider.of<LeaderboardProvider>(context, listen: false).reset();
}