import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'joystick.dart';
import 'telemetry.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URSA Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'URSA Control'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  void onChanged(int x, int y) {
    print("$x, $y");

    // send data to robot
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SlidingUpPanel(
        slideDirection: SlideDirection.DOWN,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        minHeight: 250,
        maxHeight: 400,
        panel: Telemetry(),
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Joystick(onPositionChange: onChanged),
          ],
        ),
      ),
    );
  }
}
