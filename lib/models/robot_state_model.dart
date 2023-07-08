import 'package:flutter/material.dart';

import '../domain/dtos/telemetry_message.dart';

class RobotStateModel extends ChangeNotifier {
  static final RobotStateModel _instance = RobotStateModel._internal();

  factory RobotStateModel() {
    return _instance;
  }

  RobotStateModel._internal();

  bool? enabled;
  bool? tipped;
  int? robotId;
  int? modelNumber;
  double? pitch;
  int? voltage;
  int? leftMotorSpeed;
  int? rightMotorSpeed;
  int? auxLength;
  bool? containsPid;
  double? pitchTarget;
  double? pitchOffset;
  double? speedP;
  double? speedI;
  double? speedD;
  double? angleP;
  double? angleI;
  double? angleD;

  DateTime? lastMessageTime;

  void setFromTelemetry(TelemetryMessage value) {
    int hash1 = hashCode;

    enabled = value.enabled;
    tipped = value.tipped;
    robotId = value.robotId;
    modelNumber = value.modelNumber;
    pitch = value.pitch;
    voltage = value.voltage;
    leftMotorSpeed = value.leftMotorSpeed;
    rightMotorSpeed = value.rightMotorSpeed;
    auxLength = value.auxLength;
    containsPid = value.containsPid;
    pitchTarget = value.pitchTarget;
    pitchOffset = value.pitchOffset;
    speedP = value.speedP;
    speedI = value.speedI;
    speedD = value.speedD;
    angleP = value.angleP;
    angleI = value.angleI;
    angleD = value.angleD;

    lastMessageTime = DateTime.now();

    // Only notify listeners if something changed
    if (hash1 != hashCode) {
      notifyListeners();
    }
  }

  @override
  int get hashCode => Object.hash(
        enabled,
        tipped,
        robotId,
        modelNumber,
        pitch,
        voltage,
        leftMotorSpeed,
        rightMotorSpeed,
        auxLength,
        containsPid,
        pitchTarget,
        pitchOffset,
        speedP,
        speedI,
        speedD,
        angleP,
        angleI,
        angleD,
        lastMessageTime,
      );

  @override
  bool operator ==(Object other) {
    if (other is RobotStateModel) {
      return enabled == other.enabled &&
          tipped == other.tipped &&
          robotId == other.robotId &&
          modelNumber == other.modelNumber &&
          pitch == other.pitch &&
          voltage == other.voltage &&
          leftMotorSpeed == other.leftMotorSpeed &&
          rightMotorSpeed == other.rightMotorSpeed &&
          auxLength == other.auxLength &&
          containsPid == other.containsPid &&
          pitchTarget == other.pitchTarget &&
          pitchOffset == other.pitchOffset &&
          speedP == other.speedP &&
          speedI == other.speedI &&
          speedD == other.speedD &&
          angleP == other.angleP &&
          angleI == other.angleI &&
          angleD == other.angleD &&
          lastMessageTime == other.lastMessageTime;
    }

    return false;
  }
}
