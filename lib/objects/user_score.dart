import 'package:flutter/material.dart';

class UserScore {
  String name;
  int score;
  Color avatarColor;

  UserScore(
      {required this.name, required this.score, required this.avatarColor});

  factory UserScore.fromJson(Map<String, dynamic> json) {
    Color c = Colors.purple;
    switch (json['color']) {
      case "Green":
        c = Colors.green;
        break;
      case "Orange":
        c = Colors.orange;
        break;
      case "Blue":
        c = Colors.blue;
        break;
      // add more colors in the future
    }
    return UserScore(
      name: json['name'],
      score: json['score'],
      avatarColor: c,
      // avatarColor: json['avatarColor'], // implement this in server
    );
  }
}
