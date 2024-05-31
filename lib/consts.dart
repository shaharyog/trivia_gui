import 'package:flutter/material.dart';
import 'package:trivia/utils/filters.dart';
import 'package:trivia/src/rust/api/request/get_room_players.dart';
import 'src/rust/api/request/create_room.dart';
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
const bool defaultShowOnlyActive = false;
const SortBy defaultSortBy = SortBy.isActive;
const bool defaultPutActiveRoomsFirst = false;
const bool defaultIsReversedSort = false;

// screen size related consts:
const minScreenSize = Size(500, 700);
const defaultScreenSize = Size(800, 600);

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
    id: '',
    isActive: false,
    roomData: RoomData(
      name: 'room',
      maxPlayers: 100,
      questionCount: 0,
      timePerQuestion: 10,
    ),
    players: [
      Player(username: "Bob Doe", avatarColor: "Blue", score: 130)
    ],
  ),
  const Room(
    id: '',
    roomData: RoomData(
      name: 'roomRoomRo',
      maxPlayers: 10,
      questionCount: 45,
      timePerQuestion: 0,
    ),
    players: [
      Player(username: "Robert Doe", avatarColor: "Orange", score: 90)
    ],
    isActive: false,
  ),
  const Room(
    id: '',
    roomData: RoomData(
      name: 'roomRoom',
      maxPlayers: 0,
      questionCount: 100,
      timePerQuestion: 10,
    ),
    players: [
      Player(username: "John Doe", avatarColor: "Blue", score: 100)
    ],
    isActive: false,
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