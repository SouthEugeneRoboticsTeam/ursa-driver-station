import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import '../models/connection_model.dart';
import '../models/telemetry_model.dart';
import 'dtos/command_message.dart';
import 'dtos/telemetry_message.dart';
import 'networking.dart';

CommandMessage commandMessage = CommandMessage();
CommandMessage _previousCommandMessage = CommandMessage();

Timer? connectionTimeoutTimer;

RawDatagramSocket? socket;
Timer? sendLoop;
StreamSubscription? subscription;

DateTime? lastMessageSend;

Future initConnection() async {
  Connectivity().onConnectivityChanged.listen(connectivityChangedListener);

  Timer.periodic(const Duration(seconds: 5), (_) async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    connectivityChangedListener(result);
  });
}

Future connectivityChangedListener(ConnectivityResult result) async {
  bool robotConnected = await isRobotConnected();
  InternetAddress? robotAddress = await getRobotAddress();

  if (robotConnected) {
    await initSocket(robotAddress ?? InternetAddress.anyIPv4);
    initSendLoop();
    receiveData(telemetryMessageListener);

    TelemetryMessage? latestMessage = TelemetryModel().telemetryMessage;

    // if telemetryMessage is older than 2 seconds...
    if (latestMessage == null ||
        latestMessage.messageTime
            .isBefore(DateTime.now().subtract(const Duration(seconds: 2)))) {
      ConnectionModel().setStatus(ConnectionStatus.networkConnected);
    }
  } else {
    ConnectionModel().setStatus(ConnectionStatus.disconnected);
  }
}

Future initSocket(InternetAddress host) async {
  socket?.close();

  socket = await RawDatagramSocket.bind(host, 0);
}

void initSendLoop() {
  sendLoop?.cancel();

  sendLoop = Timer.periodic(
    const Duration(milliseconds: 10),
    (Timer t) {
      // Send message if...
      //   1. The message has changed AND we haven't sent a message in the past 20ms, OR
      //   2. We haven't sent a message in the past 500ms
      //
      // TODO: We should replace #2 with a heartbeat message

      bool messageChanged = commandMessage != _previousCommandMessage;
      bool messageSentRecently = lastMessageSend != null &&
          lastMessageSend!.isAfter(
            DateTime.now().subtract(const Duration(milliseconds: 20)),
          );
      bool messageSentLongAgo = lastMessageSend == null ||
          lastMessageSend!.isBefore(
            DateTime.now().subtract(const Duration(milliseconds: 500)),
          );

      if ((messageChanged && !messageSentRecently) || messageSentLongAgo) {
        sendData(commandMessage.getBytes());

        lastMessageSend = DateTime.now();
        _previousCommandMessage = CommandMessage.from(commandMessage);
      }
    },
  );
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
    print('Could not send data, ensure robot is connected');
  }
}

void setEnabledCommand(bool enabled) {
  commandMessage.enabled = enabled;
}

void setJoystickCommand(StickDragDetails details) {
  commandMessage.speed = (details.y * -100).round();
  commandMessage.turn = (details.x * 100).round();
}

void setPidCommand(
  double angleP,
  double angleI,
  double angleD,
  double speedP,
  double speedI,
  double speedD, {
  bool save = false,
}) {
  commandMessage.advanced = true;
  commandMessage.saveRecallState = save ? 2 : 1;

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

  // If the enabled state has changed, update the UI
  if (message.enabled != _previousCommandMessage.enabled) {
    setEnabledCommand(message.enabled);
  }

  // Expect a message at least every 2 seconds
  connectionTimeoutTimer?.cancel();
  connectionTimeoutTimer = Timer(const Duration(milliseconds: 2000), () {
    if (ConnectionModel().status == ConnectionStatus.connected) {
      ConnectionModel().setStatus(ConnectionStatus.networkConnected);
    }
  });
}
