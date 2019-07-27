import 'package:flutter/foundation.dart';

class AppState {
  final ControlMode controlMode;

  AppState({
    @required this.controlMode,
  });

  AppState.initialState()
      : controlMode = ControlMode.Joystick;
}

enum ControlMode { Tilt, Joystick }
