import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MaterialApp(
    title: 'URSA Control',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: HomePage(),
  ));
}
