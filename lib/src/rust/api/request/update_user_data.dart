// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.34.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class UpdateUserDataRequest {
  final String? password;
  final String email;
  final String address;
  final String phoneNumber;
  final String avatarColor;

  const UpdateUserDataRequest({
    this.password,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.avatarColor,
  });

  @override
  int get hashCode =>
      password.hashCode ^
      email.hashCode ^
      address.hashCode ^
      phoneNumber.hashCode ^
      avatarColor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateUserDataRequest &&
          runtimeType == other.runtimeType &&
          password == other.password &&
          email == other.email &&
          address == other.address &&
          phoneNumber == other.phoneNumber &&
          avatarColor == other.avatarColor;
}
