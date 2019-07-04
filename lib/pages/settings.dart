import 'package:flutter/material.dart';
import '../drawer.dart';

class SettingsPage extends StatelessWidget {
  void onChanged(bool value) {
    print("$value");

    // send data to robot
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: NavigationDrawer(),
      body: Column(
        children: [
          Checkbox(value: true, onChanged: onChanged),
        ],
      ),
    );
  }
}