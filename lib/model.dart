import 'package:flutter/foundation.dart';
import 'package:ursa_ds_mobile/domain/incomingMessage.dart';

class AppState {
  final ControlMode controlMode;
  final IncomingMessage incomingMessage;
  final bool connected;

  AppState({
    @required this.controlMode,
    @required this.incomingMessage,
    @required this.connected,
  });

  AppState.initialState()
      : controlMode = ControlMode.Joystick,
        incomingMessage = IncomingMessage.empty(),
        connected = false;
}

enum ControlMode { Tilt, Joystick }
