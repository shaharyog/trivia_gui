// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.34.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'error.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'request/create_room.dart';
import 'request/get_game_results.dart';
import 'request/get_question.dart';
import 'request/get_room_players.dart';
import 'request/get_room_state.dart';
import 'request/get_rooms.dart';
import 'request/get_user_data.dart';
import 'request/login.dart';
import 'request/signup.dart';
import 'request/update_user_data.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Session>>
@sealed
class Session extends RustOpaque {
  Session.dcoDecode(List<dynamic> wire) : super.dcoDecode(wire, _kStaticData);

  Session.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_Session,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_Session,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_SessionPtr,
  );

  Future<void> closeRoom({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionCloseRoom(that: this, hint: hint);

  Future<void> createRoom({required RoomData roomData, dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionCreateRoom(
          that: this, roomData: roomData, hint: hint);

  static Future<void> forgotPassword(
          {required String email, required String address, dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionForgotPassword(
          email: email, address: address, hint: hint);

  Future<GameResults> getGameResults({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionGetGameResults(that: this, hint: hint);

  Future<List<Player>> getHighscores({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionGetHighscores(that: this, hint: hint);

  Future<Question> getQuestion({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionGetQuestion(that: this, hint: hint);

  Future<List<Player>> getRoomPlayers({required String roomId, dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionGetRoomPlayers(
          that: this, roomId: roomId, hint: hint);

  Future<RoomState> getRoomState({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionGetRoomState(that: this, hint: hint);

  Future<List<Room>> getRooms({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionGetRooms(that: this, hint: hint);

  Future<UserDataAndStatistics> getUserData({dynamic hint}) =>
      RustLib.instance.api
          .crateApiSessionSessionGetUserData(that: this, hint: hint);

  Future<void> joinRoom({required String roomId, dynamic hint}) => RustLib
      .instance.api
      .crateApiSessionSessionJoinRoom(that: this, roomId: roomId, hint: hint);

  Future<void> leaveGame({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionLeaveGame(that: this, hint: hint);

  Future<void> leaveRoom({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionLeaveRoom(that: this, hint: hint);

  static Future<Session> login(
          {required LoginRequest loginRequest,
          required String address,
          dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionLogin(
          loginRequest: loginRequest, address: address, hint: hint);

  Future<void> logout({dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionLogout(that: this, hint: hint);

  Future<void> resendVerificationCode({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionResendVerificationCode(that: this, hint: hint);

  static Future<Session> signup(
          {required SignupRequest signupRequest,
          required String address,
          dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionSignup(
          signupRequest: signupRequest, address: address, hint: hint);

  Future<void> startGame({dynamic hint}) => RustLib.instance.api
      .crateApiSessionSessionStartGame(that: this, hint: hint);

  Future<int> submitAnswer(
          {required int answerId, required int questionId, dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionSubmitAnswer(
          that: this, answerId: answerId, questionId: questionId, hint: hint);

  Future<bool> submitVerificationCode({required String code, dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionSubmitVerificationCode(
          that: this, code: code, hint: hint);

  Future<void> updateUserData(
          {required UpdateUserDataRequest updateUserDataRequest,
          dynamic hint}) =>
      RustLib.instance.api.crateApiSessionSessionUpdateUserData(
          that: this, updateUserDataRequest: updateUserDataRequest, hint: hint);
}
