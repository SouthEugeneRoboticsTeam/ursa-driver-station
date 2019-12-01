import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ursa_ds_mobile/domain/communications.dart';
import 'package:ursa_ds_mobile/domain/incomingMessage.dart';
import 'package:ursa_ds_mobile/enableToggle.dart';
import 'package:ursa_ds_mobile/model.dart';

final random = new Random();

class Telemetry extends StatefulWidget {
  const Telemetry({Key key}) : super(key: key);

  @override
  TelemetryState createState() => TelemetryState();
}

class TelemetryState extends State<Telemetry> {
  List<int> batteryValues = List.filled(32, 0, growable: true);

  Widget container(IconData icon, Color color, String label) {
    return Container(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: color,
            ),
            child: Icon(icon, size: 50),
          ),
          Text(label)
        ],
      ),
    );
  }

  int batteryCharge(double voltage) => (voltage / 255 * 100).round();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (context, _ViewModel viewModel) {
        batteryValues.removeAt(0);
        batteryValues.add(viewModel.message.voltage);

        var batteryAvg = batteryValues.fold(0, (p, c) => p + c) / batteryValues.length;

        var battery = batteryCharge(batteryAvg);
        var pitch = viewModel.message.pitch.round();

        var messageTime = viewModel.message.messageTime;
        var currentTime = DateTime.now().millisecondsSinceEpoch;

        var wifiColor = Colors.red[300];
        var wifiMessage = 'Disconnected';
        if (viewModel.connected && currentTime - messageTime < 200) {
          wifiColor = Colors.green[300];
          wifiMessage = 'Connected';
        } else if (viewModel.connected) {
          wifiColor = Colors.yellow[300];
          wifiMessage = 'Connected';
        }

        var pitchColor = Colors.red[300];
        if (pitch.abs() <= 25) {
          pitchColor = Colors.green[300];
        } else if (pitch.abs() <= 50) {
          pitchColor = Colors.yellow[300];
        }

        var batteryColor = Colors.red[300];
        if (battery >= 60) {
          batteryColor = Colors.green[300];
        } else if (battery >= 40) {
          batteryColor = Colors.yellow[300];
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                container(Icons.network_wifi, wifiColor, wifiMessage),
                container(Icons.rotate_90_degrees_ccw, pitchColor, '$pitch°'),
                container(Icons.battery_charging_full, batteryColor, '$battery%'),
              ],
            ),
            EnableToggle(),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final IncomingMessage message;
  final bool connected;

  _ViewModel({
    this.message,
    this.connected,
  });

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(
      message: store.state.incomingMessage,
      connected: store.state.connected
    );
  }
}
