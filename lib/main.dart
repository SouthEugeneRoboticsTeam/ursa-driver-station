import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ursa_ds_mobile/domain/communications.dart';
import 'package:ursa_ds_mobile/model.dart';
import 'package:ursa_ds_mobile/pages/home.dart';
import 'package:ursa_ds_mobile/store/reducer.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);

  initSocket().then((x) {
    initSendLoop();

    receiveData((String data) {
      print('$data');
    });
  });

  runApp(UrsaApp());
}

final Store store = Store<AppState>(
  appStateReducer,
  initialState: AppState.initialState(),
);

class UrsaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreProvider<AppState>(
    store: store,
    child: MaterialApp(
      title: 'URSA Control',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    ),
  );
}
