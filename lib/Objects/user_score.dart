class UserScore {
  String name;
  int score;

  UserScore({required this.name, required this.score});

  factory UserScore.fromJson(Map<String, dynamic> json) {
    return UserScore(
      name: json['name'],
      score: json['score'],
    );
  }
}