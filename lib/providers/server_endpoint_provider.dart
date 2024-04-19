import 'package:flutter/material.dart';

import '../consts.dart';

class ServerEndpointProvider with ChangeNotifier {
  String _serverIp = defaultServerIp;
  int _port = defaultPort;

  String get serverIp => _serverIp;

  int get port => _port;

  void setServerIp(String serverIp) {
    _serverIp = serverIp;
  }

  void resetServerIp() {
    _serverIp = "127.0.0.1";
  }

  void setPort(int port) {
    _port = port;
  }

  void resetPort() {
    _port = defaultPort;
  }
}
