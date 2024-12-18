// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.34.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'get_room_players.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class RoomState {
  final bool hasGameBegun;
  final List<Player> players;
  final int questionCount;
  final int answerTimeout;
  final int maxPlayers;
  final bool isClosed;

  const RoomState({
    required this.hasGameBegun,
    required this.players,
    required this.questionCount,
    required this.answerTimeout,
    required this.maxPlayers,
    required this.isClosed,
  });

  @override
  int get hashCode =>
      hasGameBegun.hashCode ^
      players.hashCode ^
      questionCount.hashCode ^
      answerTimeout.hashCode ^
      maxPlayers.hashCode ^
      isClosed.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomState &&
          runtimeType == other.runtimeType &&
          hasGameBegun == other.hasGameBegun &&
          players == other.players &&
          questionCount == other.questionCount &&
          answerTimeout == other.answerTimeout &&
          maxPlayers == other.maxPlayers &&
          isClosed == other.isClosed;
}
