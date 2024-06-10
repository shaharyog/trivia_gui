// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/error.dart';
import 'api/request/create_room.dart';
import 'api/request/get_game_results.dart';
import 'api/request/get_question.dart';
import 'api/request/get_room_players.dart';
import 'api/request/get_room_state.dart';
import 'api/request/get_rooms.dart';
import 'api/request/get_user_data.dart';
import 'api/request/login.dart';
import 'api/request/signup.dart';
import 'api/request/update_user_data.dart';
import 'api/session.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_SessionPtr => wire
      ._rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSessionPtr;

  @protected
  Session
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          dynamic raw);

  @protected
  Session
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          dynamic raw);

  @protected
  DateTime dco_decode_Chrono_Naive(dynamic raw);

  @protected
  Session
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  Error dco_decode_box_autoadd_error(dynamic raw);

  @protected
  LoginRequest dco_decode_box_autoadd_login_request(dynamic raw);

  @protected
  RoomData dco_decode_box_autoadd_room_data(dynamic raw);

  @protected
  SignupRequest dco_decode_box_autoadd_signup_request(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_32(dynamic raw);

  @protected
  UpdateUserDataRequest dco_decode_box_autoadd_update_user_data_request(
      dynamic raw);

  @protected
  Error dco_decode_error(dynamic raw);

  @protected
  GameResults dco_decode_game_results(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  int dco_decode_i_64(dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<Player> dco_decode_list_player(dynamic raw);

  @protected
  List<PlayerResult> dco_decode_list_player_result(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<QuestionAnswered> dco_decode_list_question_answered(dynamic raw);

  @protected
  List<(int, String)> dco_decode_list_record_u_32_string(dynamic raw);

  @protected
  List<Room> dco_decode_list_room(dynamic raw);

  @protected
  LoginRequest dco_decode_login_request(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_32(dynamic raw);

  @protected
  Player dco_decode_player(dynamic raw);

  @protected
  PlayerResult dco_decode_player_result(dynamic raw);

  @protected
  Question dco_decode_question(dynamic raw);

  @protected
  QuestionAnswered dco_decode_question_answered(dynamic raw);

  @protected
  (int, String) dco_decode_record_u_32_string(dynamic raw);

  @protected
  Room dco_decode_room(dynamic raw);

  @protected
  RoomData dco_decode_room_data(dynamic raw);

  @protected
  RoomState dco_decode_room_state(dynamic raw);

  @protected
  SignupRequest dco_decode_signup_request(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  UpdateUserDataRequest dco_decode_update_user_data_request(dynamic raw);

  @protected
  UserData dco_decode_user_data(dynamic raw);

  @protected
  UserDataAndStatistics dco_decode_user_data_and_statistics(dynamic raw);

  @protected
  UserStatistics dco_decode_user_statistics(dynamic raw);

  @protected
  int dco_decode_usize(dynamic raw);

  @protected
  Session
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          SseDeserializer deserializer);

  @protected
  Session
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          SseDeserializer deserializer);

  @protected
  DateTime sse_decode_Chrono_Naive(SseDeserializer deserializer);

  @protected
  Session
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  Error sse_decode_box_autoadd_error(SseDeserializer deserializer);

  @protected
  LoginRequest sse_decode_box_autoadd_login_request(
      SseDeserializer deserializer);

  @protected
  RoomData sse_decode_box_autoadd_room_data(SseDeserializer deserializer);

  @protected
  SignupRequest sse_decode_box_autoadd_signup_request(
      SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  UpdateUserDataRequest sse_decode_box_autoadd_update_user_data_request(
      SseDeserializer deserializer);

  @protected
  Error sse_decode_error(SseDeserializer deserializer);

  @protected
  GameResults sse_decode_game_results(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  int sse_decode_i_64(SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<Player> sse_decode_list_player(SseDeserializer deserializer);

  @protected
  List<PlayerResult> sse_decode_list_player_result(
      SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<QuestionAnswered> sse_decode_list_question_answered(
      SseDeserializer deserializer);

  @protected
  List<(int, String)> sse_decode_list_record_u_32_string(
      SseDeserializer deserializer);

  @protected
  List<Room> sse_decode_list_room(SseDeserializer deserializer);

  @protected
  LoginRequest sse_decode_login_request(SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  Player sse_decode_player(SseDeserializer deserializer);

  @protected
  PlayerResult sse_decode_player_result(SseDeserializer deserializer);

  @protected
  Question sse_decode_question(SseDeserializer deserializer);

  @protected
  QuestionAnswered sse_decode_question_answered(SseDeserializer deserializer);

  @protected
  (int, String) sse_decode_record_u_32_string(SseDeserializer deserializer);

  @protected
  Room sse_decode_room(SseDeserializer deserializer);

  @protected
  RoomData sse_decode_room_data(SseDeserializer deserializer);

  @protected
  RoomState sse_decode_room_state(SseDeserializer deserializer);

  @protected
  SignupRequest sse_decode_signup_request(SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  UpdateUserDataRequest sse_decode_update_user_data_request(
      SseDeserializer deserializer);

  @protected
  UserData sse_decode_user_data(SseDeserializer deserializer);

  @protected
  UserDataAndStatistics sse_decode_user_data_and_statistics(
      SseDeserializer deserializer);

  @protected
  UserStatistics sse_decode_user_statistics(SseDeserializer deserializer);

  @protected
  int sse_decode_usize(SseDeserializer deserializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          Session self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          Session self, SseSerializer serializer);

  @protected
  void sse_encode_Chrono_Naive(DateTime self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
          Session self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_error(Error self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_login_request(
      LoginRequest self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_room_data(
      RoomData self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_signup_request(
      SignupRequest self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_update_user_data_request(
      UpdateUserDataRequest self, SseSerializer serializer);

  @protected
  void sse_encode_error(Error self, SseSerializer serializer);

  @protected
  void sse_encode_game_results(GameResults self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_i_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_player(List<Player> self, SseSerializer serializer);

  @protected
  void sse_encode_list_player_result(
      List<PlayerResult> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_question_answered(
      List<QuestionAnswered> self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_u_32_string(
      List<(int, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_room(List<Room> self, SseSerializer serializer);

  @protected
  void sse_encode_login_request(LoginRequest self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_32(int? self, SseSerializer serializer);

  @protected
  void sse_encode_player(Player self, SseSerializer serializer);

  @protected
  void sse_encode_player_result(PlayerResult self, SseSerializer serializer);

  @protected
  void sse_encode_question(Question self, SseSerializer serializer);

  @protected
  void sse_encode_question_answered(
      QuestionAnswered self, SseSerializer serializer);

  @protected
  void sse_encode_record_u_32_string(
      (int, String) self, SseSerializer serializer);

  @protected
  void sse_encode_room(Room self, SseSerializer serializer);

  @protected
  void sse_encode_room_data(RoomData self, SseSerializer serializer);

  @protected
  void sse_encode_room_state(RoomState self, SseSerializer serializer);

  @protected
  void sse_encode_signup_request(SignupRequest self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_update_user_data_request(
      UpdateUserDataRequest self, SseSerializer serializer);

  @protected
  void sse_encode_user_data(UserData self, SseSerializer serializer);

  @protected
  void sse_encode_user_data_and_statistics(
      UserDataAndStatistics self, SseSerializer serializer);

  @protected
  void sse_encode_user_statistics(
      UserStatistics self, SseSerializer serializer);

  @protected
  void sse_encode_usize(int self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  factory RustLibWire.fromExternalLibrary(ExternalLibrary lib) =>
      RustLibWire(lib.ffiDynamicLibrary);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustLibWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
      ptr,
    );
  }

  late final _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSessionPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'frbgen_trivia_rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession');
  late final _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession =
      _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSessionPtr
          .asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession(
      ptr,
    );
  }

  late final _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSessionPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'frbgen_trivia_rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession');
  late final _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSession =
      _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSessionPtr
          .asFunction<void Function(ffi.Pointer<ffi.Void>)>();
}
