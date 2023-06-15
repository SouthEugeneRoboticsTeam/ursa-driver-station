import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ursa_ds_mobile/pages/config_page.dart';

import 'domain/connection.dart';
import 'domain/networking.dart';
import 'domain/sentry.dart';
import 'models/connection_model.dart';
import 'pages/joystick_page.dart';

void main() async {
  initSentry(() => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConnectionModel()),
      ],
      child: const UrsaApp(),
    ),
  ));

  // BluetoothProvider().getConnectedDevices();
  // BluetoothProvider().getBondedDevices();

  // BluetoothProvider().doSomething();

  initConnection();
}


class UrsaApp extends StatelessWidget {
  const UrsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URSA Control',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      // home: const JoystickPage(),
      routes: {
        '/' : (context) => const JoystickPage(),
        '/config' : (context) => const ConfigPage(),
      },
    );
  }
}
