import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/filters_providers/rooms_filters_provider.dart';
import '../../providers/leaderboard_provider.dart';

void resetProviders(BuildContext context) {
  Provider.of<FiltersProvider>(context, listen: false).reset();
  Provider.of<LeaderboardProvider>(context, listen: false).reset();
}