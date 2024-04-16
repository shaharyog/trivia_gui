class Room {
  String uuid;
  String name;
  int maxPlayers;
  List<String> players;
  int questionsCount;
  int timePerQuestion;
  bool isActive;

  Room({
    required this.uuid,
    required this.name,
    required this.maxPlayers,
    required this.players,
    required this.questionsCount,
    required this.timePerQuestion,
    required this.isActive,
  });
}
