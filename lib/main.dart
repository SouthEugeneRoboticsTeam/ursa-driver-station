import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'domain/communications.dart';
import 'pages/home.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);

  initSocket().then((x) {
    initSendLoop();

    receiveData((String data) {
      print('$data');
    });
  });

  runApp(MaterialApp(
    title: 'URSA Control',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: HomePage(),
  ));
}
