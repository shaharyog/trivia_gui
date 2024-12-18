import 'package:flutter/material.dart';
import 'package:trivia/src/rust/api/request/get_question.dart';
import 'package:trivia/src/rust/api/request/get_room_state.dart';
import 'package:trivia/utils/filters.dart';
import 'package:trivia/src/rust/api/request/get_room_players.dart';
import 'src/rust/api/request/create_room.dart';
import 'src/rust/api/request/get_game_results.dart';
import 'src/rust/api/request/get_rooms.dart';
import 'src/rust/api/request/get_user_data.dart';

const Size signInAndUpButtonSize = Size(200, 60);
const double maxTextFieldWidth = 400;

// server settings defaults:
const String defaultPort = "8826";
const String serverPortKey = 'serverPortKey';
const String defaultServerIp = "127.0.0.1";
const String serverIpKey = 'serverIpKey';

const String serverConnErrorText = 'Server Connection Error';
const String logoutErrorText = 'Logout Error';
const String unknownErrorText = "Error";

// filters related defaults:
const String defaultSearchText = "";
const double defaultQuestionCountRangeStart = 1;
const double defaultQuestionCountRangeEnd = 50;
const double defaultPlayersCountRangeStart = 1;
const double defaultPlayersCountRangeEnd = 50;
const bool defaultShowActive = true;
const bool defaultShowInactive = true;
const bool defaultShowFinished = true;
const SortBy defaultSortBy = SortBy.isActive;
const bool defaultPutActiveRoomsFirst = false;
const bool defaultIsReversedSort = false;

// screen size related consts:
const minScreenSize = Size(500, 800);
const defaultScreenSize = Size(600, 800);

// animations durations:
const int defaultBlinkingCircleDuration = 550;

// color scheme related consts:
const defaultLightColorScheme = ColorScheme.light();
const defaultDarkColorScheme = ColorScheme.dark();

// // avatar colors:
List<ColorSwatch>? avatarColors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.cyan,
  Colors.teal,
  Colors.pink
];

Map<String, Color> avatarColorsMap = {
  "Blue": Colors.blue,
  "Red": Colors.red,
  "Green": Colors.green,
  "Purple": Colors.purple,
  "Orange": Colors.orange,
  "Cyan": Colors.cyan,
  "Teal": Colors.teal,
  "Pink": Colors.pink
};

Map<Color, String> avatarColorsMapReversed = {
  Colors.blue: "Blue",
  Colors.red: "Red",
  Colors.green: "Green",
  Colors.purple: "Purple",
  Colors.orange: "Orange",
  Colors.cyan: "Cyan",
  Colors.teal: "Teal",
  Colors.pink: "Pink"
};

// show skeleton while loading, create fake data in order to show skeleton in the right shape
final List<Room> fakeRooms = [
  const Room(
    isFinished: true,
    id: '',
    isActive: true,
    roomData: RoomData(
      name: 'room',
      maxPlayers: 100,
      questionCount: 0,
      timePerQuestion: 10,
    ),
    players: [Player(username: "Bob Doe", avatarColor: "Blue", score: 130)],
  ),
  const Room(
    isFinished: false,
    id: '',
    roomData: RoomData(
      name: 'roomRoomRo',
      maxPlayers: 10,
      questionCount: 45,
      timePerQuestion: 0,
    ),
    players: [Player(username: "Robert Doe", avatarColor: "Orange", score: 90)],
    isActive: false,
  ),
  const Room(
    isFinished: false,
    id: '',
    roomData: RoomData(
      name: 'roomRoom',
      maxPlayers: 0,
      questionCount: 100,
      timePerQuestion: 10,
    ),
    players: [Player(username: "John Doe", avatarColor: "Blue", score: 100)],
    isActive: true,
  )
];

// show skeleton while loading, create fake data in order to show skeleton in the right shape
final UserDataAndStatistics fakeUserDataAndStats = UserDataAndStatistics(
  userData: UserData(
    username: "username",
    email: "username@gmail.com",
    address: "Street, 123, City",
    phoneNumber: "0555555555",
    birthday: "01/01/2000",
    avatarColor: "Blue",
    memberSince: DateTime(2000, 1, 1),
  ),
  userStatistics: const UserStatistics(
      averageAnswerTime: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      totalAnswers: 0,
      totalGames: 0,
      score: 0),
);

const List<Player> fakeHighScoresPlayers = [
  Player(username: "John Doe", score: 100, avatarColor: "Blue"),
  Player(username: "Shahar Yogev", score: 77, avatarColor: "Blue"),
  Player(username: "Yuval Bar", score: 90, avatarColor: "Orange"),
  Player(username: "Itay Hadas", score: 123, avatarColor: "Purple"),
  Player(username: "Ohad Green", score: 12, avatarColor: "Green"),
  Player(username: "Ron Altman", score: 45, avatarColor: "Teal"),
];

const RoomState fakeRoomState = RoomState(
  hasGameBegun: false,
  players: fakeHighScoresPlayers,
  questionCount: 12,
  answerTimeout: 30,
  maxPlayers: 10,
  isClosed: false,
);

const Question fakeQuestion = Question(
    questionId: -1,
    question: "Aaaaa aaaaa aaaaaa, aaaa aaaaa aaaaa, aaaaa aaa \"aaaaa  aa \"?",
    answers: [
      (0, "aaa aaaaa aaaa aaa"),
      (3, "Aaaa aaaa aaaa aaaa"),
      (2, "aaa aaaa aaaa"),
      (1, "aaaa aaaaaaa aaaa aa aaaa aaaaaa")
    ]);
const List<PlayerResult> fakePlayerResults = [
  PlayerResult(
    username: "User user", avatarColor: "Blue",
    isOnline: false,
    scoreChange: 35,
    correctAnswerCount: 4,
    wrongAnswerCount: 4,
    avgAnswerTime: 14,
  ),
  PlayerResult(
    username: "User user", avatarColor: "Green",
    isOnline: false,
    scoreChange: -90,
    correctAnswerCount: 1,
    wrongAnswerCount: 7,
    avgAnswerTime: 8,
  ),
  PlayerResult(
   username: "User user", avatarColor: "Orange",
    isOnline: false,
    scoreChange: 90,
    correctAnswerCount: 6,
    wrongAnswerCount: 2,
    avgAnswerTime: 18,
  )
];
