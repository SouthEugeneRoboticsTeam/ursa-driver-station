import 'package:flutter/material.dart';
import 'package:ursa_ds_mobile/pages/home.dart';
import 'package:ursa_ds_mobile/pages/settings.dart';

class NavigationDrawer extends StatelessWidget {
  void navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.display4.apply(fontSizeFactor: 0.7, color: Colors.white);

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.center,
              child: Text('URSA', style: style),
            ),
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
          ),
          ListTile(
            title: Text('Controller'),
            onTap: () { navigateTo(context, HomePage()); },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () { navigateTo(context, SettingsPage()); },
          ),
        ],
      ),
    );
  }
}
