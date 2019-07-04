import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/settings.dart';

class NavigationDrawer extends StatelessWidget {
  void navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Controller"),
            onTap: () { navigateTo(context, HomePage()); },
          ),
          ListTile(
            title: Text("Settings"),
            onTap: () { navigateTo(context, SettingsPage()); },
          ),
        ],
      ),
    );
  }
}