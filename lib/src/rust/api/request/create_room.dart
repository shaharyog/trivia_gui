// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class RoomData {
  final String name;
  final int maxPlayers;
  final int questionCount;
  final int timePerQuestion;

  const RoomData({
    required this.name,
    required this.maxPlayers,
    required this.questionCount,
    required this.timePerQuestion,
  });

  @override
  int get hashCode =>
      name.hashCode ^
      maxPlayers.hashCode ^
      questionCount.hashCode ^
      timePerQuestion.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          maxPlayers == other.maxPlayers &&
          questionCount == other.questionCount &&
          timePerQuestion == other.timePerQuestion;
}