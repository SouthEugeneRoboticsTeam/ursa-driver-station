import 'package:flutter/material.dart';
import 'domain/communications.dart';
import 'enableToggle.dart';
import 'dart:math';

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
            container(Icons.network_wifi, Colors.green[300], '-38 dBm'),
            container(Icons.rotate_90_degrees_ccw, Colors.red[300], '84.3°'),
            container(Icons.battery_charging_full, Colors.yellow[300], '34%'),
          ],
        ),
        EnableToggle(),
      ],
    );
  }
}
