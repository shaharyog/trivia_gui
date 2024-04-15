import 'package:flutter/material.dart';
import '../Objects/room.dart';

class RoomsProvider extends ChangeNotifier {
  List<Room> _rooms = [
    Room(
      uuid: '1',
      name: 'Room 1',
      maxPlayers: 5,
      players: [
        'user1',
        'user2',
        'user3',
      ],
      questionsCount: 10,
      timePerQuestion: 30,
      isActive: false,
    ),
    Room(
      uuid: '2',
      name: 'Room 2',
      maxPlayers: 8,
      players: [
        'user1',
        'user2',
        'user3',
        'user4',
        'user5',
      ],
      questionsCount: 15,
      timePerQuestion: 20,
      isActive: true,
    ),
    Room(
      uuid: '3',
      name: 'Room 3',
      maxPlayers: 6,
      players: [
        'user1',
        'user2',
      ],
      questionsCount: 12,
      timePerQuestion: 25,
      isActive: false,
    ),
  ];

  List<Room> get rooms => _rooms;

  void updateRoom(Room updatedRoom) {
    final index = _rooms.indexWhere((room) => room.uuid == updatedRoom.uuid);
    if (index != -1) {
      _rooms[index] = updatedRoom;
      notifyListeners(); // Notify listeners that the state has changed
    }
  }

  void addRoom(Room newRoom) {
    _rooms.add(newRoom);
  }

  void removeRoom(String uuid) {
    _rooms.removeWhere((room) => room.uuid == uuid);
  }

  void updateRooms(List<Room> updatedRooms) {
    _rooms = updatedRooms;
  }
}
