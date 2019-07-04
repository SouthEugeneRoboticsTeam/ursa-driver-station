import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../drawer.dart';
import '../joystick.dart';
import '../telemetry.dart';

class HomePage extends StatelessWidget {
  void onChanged(int x, int y) {
    print("$x, $y");

    // send data to robot
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URSA Control'),
      ),
      drawer: NavigationDrawer(),
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