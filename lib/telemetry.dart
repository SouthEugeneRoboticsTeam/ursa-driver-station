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
  double sliderA = 0.0;
  double sliderB = 0.0;
  double sliderC = 0.0;

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

  void onChangeA(double value) {
    message.speedP = value;
    message.angleP = value;

    setState(() {
      sliderA = value;
    });
  }

  void onChangeB(double value) {
    message.speedI = value;
    message.angleI = value;

    setState(() {
      sliderB = value;
    });
  }

  void onChangeC(double value) {
    message.speedD = value;
    message.angleD = value;

    setState(() {
      sliderC = value;
    });
  }

  int batteryCharge(int voltage) => (voltage / 255 * 100).round();

  Widget slider(double value, ValueChanged<double> onChanged, String label) {
    TextEditingController controller =
        TextEditingController(text: value.toStringAsFixed(3));

    return Container(
      padding: EdgeInsets.only(right: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: 4,
            child: Slider(value: value, onChanged: onChanged),
          ),
          Flexible(
            flex: 1,
            child: TextField(
              controller: controller,
              onSubmitted: (String value) { onChanged(double.parse(value)); } ,
              decoration: InputDecoration(labelText: label),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (context, _ViewModel viewModel) {
        var pitch = viewModel.message.pitch.round();
        var battery = batteryCharge(viewModel.message.voltage);

        var messageTime = viewModel.message.messageTime;
        var currentTime = DateTime.now().millisecondsSinceEpoch;

        var wifiColor = Colors.red[300];
        var wifiMessage = 'Disconnected';
        if (viewModel.connected && currentTime - messageTime < 100) {
          wifiColor = Colors.green[300];
          wifiMessage = 'Connected';
        } else if (viewModel.connected && currentTime - messageTime < 1000) {
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
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    slider(sliderA, onChangeA, "Slider A"),
                    slider(sliderB, onChangeB, "Slider B"),
                    slider(sliderC, onChangeC, "Slider C"),
                  ],
                )
            ),
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
