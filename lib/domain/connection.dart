import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/config_model.dart';
import '../models/connection_model.dart';
import '../models/desired_state_model.dart';
import '../models/robot_state_model.dart';
import 'dtos/command_message.dart';
import 'dtos/telemetry_message.dart';
import 'networking.dart';

class ConnectionManager {
  Timer? connectionTimeoutTimer;

  RawDatagramSocket? socket;
  Timer? sendLoop;
  StreamSubscription? subscription;

  DateTime? lastMessageSend;

  ConnectionManager() {
    initConnection();
  }

  Future initConnection() async {
    Connectivity().onConnectivityChanged.listen(connectivityChangedListener);

    Timer.periodic(const Duration(seconds: 5), (_) async {
      List<ConnectivityResult> result = await Connectivity().checkConnectivity();
      connectivityChangedListener(result);
    });
  }

  Future connectivityChangedListener(List<ConnectivityResult> result) async {
    bool robotConnected = await isRobotConnected();
    InternetAddress? robotAddress = await getRobotAddress();

    if (robotConnected) {
      await initSocket(robotAddress ?? InternetAddress.anyIPv4);
      initSendLoop();
      receiveData(telemetryMessageListener);

      DateTime? latestMessageTime = RobotStateModel().lastMessageTime;

      // if telemetryMessage is older than 2 seconds...
      if (latestMessageTime == null ||
          latestMessageTime
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
      const Duration(milliseconds: 50),
      (Timer t) {
        sendData(
          CommandMessage.from(
            DesiredStateModel(),
            config: ConfigModel(),
          ).getBytes(),
        );
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

      // Reset to recall state after sending a message
      DesiredStateModel().setSaveRecallState(SaveRecallState.recall);
    } catch (e) {
      print('Could not send data, ensure robot is connected');
    }
  }

  void telemetryMessageListener(TelemetryMessage message) {
    bool? previouslyEnabled = RobotStateModel().enabled;

    RobotStateModel().setFromTelemetry(message);
    ConnectionModel().setStatus(ConnectionStatus.connected);

    // If we were previously enabled and now we're not, update DesiredStateModel
    if (previouslyEnabled == true && !message.enabled) {
      DesiredStateModel().setEnabled(false);
    }

    // Expect a message at least every 2 seconds
    connectionTimeoutTimer?.cancel();
    connectionTimeoutTimer = Timer(const Duration(milliseconds: 2000), () {
      if (ConnectionModel().status == ConnectionStatus.connected) {
        ConnectionModel().setStatus(ConnectionStatus.networkConnected);
      }
    });
  }
}
