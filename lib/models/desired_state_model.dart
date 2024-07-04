import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import '../domain/dtos/command_message.dart';

class DesiredStateModel extends ChangeNotifier {
  static final DesiredStateModel _instance = DesiredStateModel._internal();

  factory DesiredStateModel() {
    return _instance;
  }

  DesiredStateModel._internal();

  bool enabled = false;
  bool advanced = false;
  int auxiliary = 0;
  double angleP = 0;
  double angleI = 0;
  double angleD = 0;
  double speedP = 0;
  double speedI = 0;
  double speedD = 0;
  int saveRecallState = SaveRecallState.recall.value;

  // -1 to 1... mapped to 0 to 200 in the command message
  double speed = 0;
  double turn = 0;

  void setEnabled(bool value) {
    enabled = value;

    notifyListeners();
  }

  void setSpeedTurn(StickDragDetails details) {
    speed = -details.y;
    turn = details.x;

    notifyListeners();
  }

  void setPid(
    double angleP,
    double angleI,
    double angleD,
    double speedP,
    double speedI,
    double speedD, {
    bool save = false,
  }) {
    advanced = true;
    saveRecallState =
        save ? SaveRecallState.save.value : SaveRecallState.recall.value;

    this.angleP = angleP;
    this.angleI = angleI;
    this.angleD = angleD;
    this.speedP = speedP;
    this.speedI = speedI;
    this.speedD = speedD;

    notifyListeners();
  }

  void setSaveRecallState(SaveRecallState state) {
    saveRecallState = state.value;

    notifyListeners();
  }

  @override
  int get hashCode => Object.hash(
        enabled,
        advanced,
        auxiliary,
        angleP,
        angleI,
        angleD,
        speedP,
        speedI,
        speedD,
        saveRecallState,
        speed,
        turn,
      );

  @override
  bool operator ==(Object other) {
    if (other is DesiredStateModel) {
      return enabled == other.enabled &&
          advanced == other.advanced &&
          auxiliary == other.auxiliary &&
          angleP == other.angleP &&
          angleI == other.angleI &&
          angleD == other.angleD &&
          speedP == other.speedP &&
          speedI == other.speedI &&
          speedD == other.speedD &&
          saveRecallState == other.saveRecallState &&
          speed == other.speed &&
          turn == other.turn;
    }

    return false;
  }
}
