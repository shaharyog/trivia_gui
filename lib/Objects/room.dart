class Room {
  String uuid;
  String name;
  int maxPlayers;
  int playersCount;
  int questionsCount;
  int timePerQuestion;
  bool isActive;

  Room({
    required this.uuid,
    required this.name,
    required this.maxPlayers,
    required this.playersCount,
    required this.questionsCount,
    required this.timePerQuestion,
    required this.isActive,
  });
}
