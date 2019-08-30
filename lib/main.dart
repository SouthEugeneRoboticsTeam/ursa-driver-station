import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ursa_ds_mobile/domain/communications.dart';
import 'package:ursa_ds_mobile/domain/incomingMessage.dart';
import 'package:ursa_ds_mobile/model.dart';
import 'package:ursa_ds_mobile/pages/home.dart';
import 'package:ursa_ds_mobile/store/actions.dart';
import 'package:ursa_ds_mobile/store/reducer.dart';

final Store store = Store<AppState>(
  appStateReducer,
  initialState: AppState.initialState(),
);

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);

  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    var wifiIP = await (Connectivity().getWifiIP());
    print('$wifiIP');

    if (wifiIP != null && wifiIP.startsWith('10.25.21')) {
      store.dispatch(SetConnectionStatus(true));

      initSocket().then((x) {
        initSendLoop();

        receiveData((IncomingMessage data) {
          store.dispatch(SetMessageData(data));
        });
      });
    } else {
      store.dispatch(SetConnectionStatus(false));
    }
  });

  runApp(UrsaApp());
}

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
