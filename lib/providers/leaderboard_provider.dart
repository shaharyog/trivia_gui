
import 'package:flutter/material.dart';
import '../Objects/user_score.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<UserScore> _topUsers = [];

  List<UserScore> get topUsers => _topUsers;

  void setTopUsers(List<UserScore> topUsers) {
    _topUsers = topUsers;
    _sortTopUsers();
    notifyListeners();
  }

  void addTopUser(UserScore userScore) {
    _topUsers.add(userScore);
    _sortTopUsers();
    notifyListeners();
  }

  void removeTopUser(UserScore userScore) {
    _topUsers.remove(userScore);
    _sortTopUsers();
    notifyListeners();
  }

  void clearTopUsers() {
    _topUsers.clear();
    notifyListeners();
  }

  void _sortTopUsers() {
    _topUsers.sort((a, b) => b.score.compareTo(a.score));
  }
}