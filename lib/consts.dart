import 'package:flutter/material.dart';
import 'package:trivia/providers/rooms_provider.dart';

const Size initialScreenSize = Size(800, 600);
const Size minScreenSize = Size(450, 550);
const Size signInAndUpButtonSize = Size(200, 60);
const double maxTextFieldWidth = 400;

// server settings defaults:
const String defaultPort = "8826";
const String serverPortKey = 'serverPortKey';
const String defaultServerIp = "127.0.0.1";
const String serverIpKey = 'serverIpKey';

// filters related defaults:
const String defaultSearchText = "";
const double defaultQuestionCountRangeStart = 0;
const double defaultQuestionCountRangeEnd = 100;
const double defaultPlayersCountRangeStart = 0;
const double defaultPlayersCountRangeEnd = 50;
const bool defaultShowOnlyActive = false;
const SortBy defaultSortBy = SortBy.isActive;
const bool defaultPutActiveRoomsFirst = false;
const bool defaultIsReversedSort = false;

// animations durations:
const int defaultBlinkingCircleDuration = 550;

// color scheme related consts:
const defaultLightColorScheme = ColorScheme.light();
const defaultDarkColorScheme = ColorScheme.dark();
