// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// const SERVER_IP = "localhost";
// const SERVER_PORT = 8826;
//
//
// abstract class Request {
//   final int id;
//
//   Request({required this.id});
//
//   Map<String, dynamic> encodeRequestJson();
//   decodeResponseJson(responseJson);
//   sendRequest(Socket socket) async {
//     var jsonBytes = utf8.encode(jsonEncode(this.encodeRequestJson()));
//     var jsonLength = Uint8List(4)..buffer.asByteData().setInt32(0, jsonBytes.length, Endian.big);
//     socket.add([this.id] + jsonLength + jsonBytes);
//     await socket.flush();
//
//     var code = await socket.first;
//     if (code != 0) {
//       throw Exception("Error code: $code");
//     }
//
//     socket.readInto()
//   }
// }
//
// class SignInRequest extends Request {
//   SignInRequest(
//       {required username, required password})
//       : super(id: 1,
//       data: {
//         username: username,
//         password: password,
//       });
// }
//
// class SignupRequest extends Request {
//   final String username;
//   final String password;
//   final String email;
//   final String address;
//   final String phoneNumber;
//   final String birthday;
//
//   SignupRequest(
//       {required this.username, required this.password, required this.email, required this.address, required this.phoneNumber, required this.birthday})
//       : super(id: 2,);
//
//   @override
//   encodeRequestJson() {
//     return {
//       "username": username,
//       "password": password,
//       "email": email,
//       "address": address,
//       "phoneNumber": phoneNumber,
//       "birthday": birthday
//     };
//   }
// }
//
// class ApiClient {
//   Socket socket;
//
//   ApiClient({required this.socket});
//
//   Login({required username, required password}) {
//     throw UnimplementedError();
//   }
//
//   Signup( SignupRequest signupRequest) async {
//     var socket = await Socket.connect(SERVER_IP, SERVER_PORT);
//     signupRequest.sendRequest(socket);
//     ApiClient(socket: socket);
//   }
// }
