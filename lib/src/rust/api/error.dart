// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.34.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'error.freezed.dart';

@freezed
sealed class Error with _$Error {
  const Error._();

  const factory Error.serverConnectionError(
    String field0,
  ) = Error_ServerConnectionError;
  const factory Error.requestSerializationError(
    String field0,
  ) = Error_RequestSerializationError;
  const factory Error.responseDeserializationError(
    String field0,
  ) = Error_ResponseDeserializationError;
  const factory Error.requestTooBig() = Error_RequestTooBig;
  const factory Error.responseError(
    String field0,
  ) = Error_ResponseError;
  const factory Error.invalidResponseCode(
    int field0,
  ) = Error_InvalidResponseCode;
  const factory Error.loginError(
    String field0,
  ) = Error_LoginError;
  const factory Error.signupError(
    String field0,
  ) = Error_SignupError;
  const factory Error.logoutError() = Error_LogoutError;
  const factory Error.invalidAddress(
    String field0,
  ) = Error_InvalidAddress;
  const factory Error.internalServerError() = Error_InternalServerError;
  const factory Error.updateUserDataError(
    String field0,
  ) = Error_UpdateUserDataError;
  const factory Error.invalidRoomId(
    String field0,
  ) = Error_InvalidRoomId;
  const factory Error.couldNotCreateRoom() = Error_CouldNotCreateRoom;
  const factory Error.verificationCodeTooManyAttempts() =
      Error_VerificationCodeTooManyAttempts;

  String format({dynamic hint}) =>
      RustLib.instance.api.crateApiErrorErrorFormat(that: this, hint: hint);
}
