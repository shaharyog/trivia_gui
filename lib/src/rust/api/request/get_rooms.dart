// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'create_room.dart';
import 'get_room_players.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class Room {
  final String id;
  final RoomData roomData;
  final List<Player> players;
  final bool isActive;

  const Room({
    required this.id,
    required this.roomData,
    required this.players,
    required this.isActive,
  });

  @override
  int get hashCode =>
      id.hashCode ^ roomData.hashCode ^ players.hashCode ^ isActive.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Room &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          roomData == other.roomData &&
          players == other.players &&
          isActive == other.isActive;
}
