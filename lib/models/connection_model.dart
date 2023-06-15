import 'package:flutter/material.dart';

enum ConnectionStatus {
  connected,
  networkConnected,
  disconnected,
}

class ConnectionModel extends ChangeNotifier {
  static final ConnectionModel _instance = ConnectionModel._internal();

  factory ConnectionModel() {
    return _instance;
  }

  ConnectionModel._internal();

  ConnectionStatus _status = ConnectionStatus.disconnected;

  ConnectionStatus get status => _status;

  void setStatus(ConnectionStatus value) {
    _status = value;

    notifyListeners();
  }
}
