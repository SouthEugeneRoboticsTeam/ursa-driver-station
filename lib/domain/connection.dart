import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:ursa_ds_mobile/domain/dtos/command_message.dart';
import 'package:ursa_ds_mobile/domain/dtos/telemetry_message.dart';
import 'package:ursa_ds_mobile/domain/networking.dart';

import '../models/connection_model.dart';
import '../models/telemetry_model.dart';

CommandMessage commandMessage = CommandMessage();
Timer? connectionTimeoutTimer;

RawDatagramSocket? socket;
Timer? sendLoop;
StreamSubscription? subscription;

const interval = Duration(milliseconds: 50); // 20Hz refresh

Future initConnection() async {
  Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {

    print('Connection changed: $result');

    bool robotConnected = await isRobotConnected();
    InternetAddress? robotAddress = await getRobotAddress();

    print('Robot connected: $robotConnected');

    if (robotConnected) {
      await initSocket(robotAddress ?? InternetAddress.anyIPv4);
      initSendLoop();
      receiveData(telemetryMessageListener);

      ConnectionModel().setStatus(ConnectionStatus.networkConnected);
    } else {
      ConnectionModel().setStatus(ConnectionStatus.disconnected);
    }
  });
}

Future initSocket(InternetAddress host) async {
  socket?.close();

  socket = await RawDatagramSocket.bind(host, 0);
}

void initSendLoop() {
  sendLoop?.cancel();

  sendLoop = Timer.periodic(
      interval,
      (Timer t) => SchedulerBinding.instance
          .scheduleTask(() => sendData(commandMessage.getBytes()), Priority.touch));
}

void receiveData(Function(TelemetryMessage) onDataReceived) async {
  assert(socket != null);

  await subscription?.cancel();

  subscription = socket?.listen((RawSocketEvent e) {
    Datagram? d = socket?.receive();
    if (d == null) return;

    onDataReceived(TelemetryMessage(d.data));
  });
}

void sendData(List<int> message) {
  assert(socket != null);

  try {
    socket?.send(message, robotAddress, robotPort);
    commandMessage.saveRecallState = 1;
  } catch (e) {
    print("Could not send data, ensure robot is connected");
  }
}

void setEnabledCommand(bool enabled) {
  commandMessage.enabled = enabled;
}

void setJoystickCommand(StickDragDetails details) {
  commandMessage.speed = (details.x * 100).round();
  commandMessage.turn = (details.y * 100).round();
}

void setPidCommand(double angleP, double angleI, double angleD, double speedP, double speedI, double speedD) {
  commandMessage.advanced = true;
  commandMessage.saveRecallState = 2;

  commandMessage.angleP = angleP;
  commandMessage.angleI = angleI;
  commandMessage.angleD = angleD;
  commandMessage.speedP = speedP;
  commandMessage.speedI = speedI;
  commandMessage.speedD = speedD;
}

void telemetryMessageListener(TelemetryMessage message) {
  TelemetryModel().setTelemetry(message);
  ConnectionModel().setStatus(ConnectionStatus.connected);

  // Expect a message at least every 2 seconds
  connectionTimeoutTimer?.cancel();
  connectionTimeoutTimer = Timer(const Duration(milliseconds: 2000), () {
    if (ConnectionModel().status == ConnectionStatus.connected) {
      ConnectionModel().setStatus(ConnectionStatus.networkConnected);
    }
  });
}
