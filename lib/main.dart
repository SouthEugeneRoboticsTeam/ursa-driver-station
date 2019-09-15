import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ursa_ds_mobile/domain/communications.dart';
import 'package:ursa_ds_mobile/domain/incomingMessage.dart';
import 'package:ursa_ds_mobile/model.dart';
import 'package:ursa_ds_mobile/pages/home.dart';
import 'package:ursa_ds_mobile/store/actions.dart';
import 'package:ursa_ds_mobile/store/store.dart';

void main() {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    var wifiIP = await (Connectivity().getWifiIP());
    print('IP: $wifiIP');

    if (wifiIP != null && wifiIP.startsWith('10.25.21')) {
      store.dispatch(SetConnectionStatus(true));

      initSocket().then((_) {
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
