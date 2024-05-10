
import 'package:flutter/material.dart';
import '../Objects/user_score.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<UserScore> _topUsers = [
    UserScore(name: 'yuval bar 123', score: 1000, avatarColor: Colors.green),
    UserScore(name: 'tuna', score: 900, avatarColor: Colors.green),
    UserScore(name: 'shahar', score: 800, avatarColor: Colors.blue),
    UserScore(name: 'omer', score: 345, avatarColor: Colors.orange),
    UserScore(name: 'nagar', score: 300, avatarColor:  Colors.orange),
    UserScore(name: 'yuval bar 2', score: 280, avatarColor: Colors.orange),
    UserScore(name: 'tuna 2', score: 250, avatarColor: Colors.blue),
    UserScore(name: 'shahar 2', score: 200, avatarColor: Colors.orange),
    UserScore(name: 'omer 2', score: 150, avatarColor: Colors.green),
    UserScore(name: 'nagar 2', score: 100, avatarColor: Colors.blue),
  ];

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