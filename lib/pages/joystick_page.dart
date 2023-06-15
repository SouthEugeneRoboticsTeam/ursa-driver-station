import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_joystick/flutter_joystick.dart' as joystick;
import 'package:provider/provider.dart';
import 'package:ursa_ds_mobile/domain/connection.dart';
import 'package:ursa_ds_mobile/models/connection_model.dart';
import 'package:ursa_ds_mobile/models/telemetry_model.dart';

import '../components/enable.dart';
import '../components/joystick/joystick.dart';
import '../components/model_viewer/model_viewer_stub.dart' // Stub implementation
  if (dart.library.io) '../components/model_viewer/model_viewer_native.dart' // dart:io implementation
  if (dart.library.html) '../components/model_viewer/model_viewer_web.dart'; // dart:html implementation
import '../components/status.dart';


class JoystickPage extends StatefulWidget {
  const JoystickPage({Key? key}) : super(key: key);

  @override
  JoystickPageState createState() => JoystickPageState();
}

class JoystickPageState extends State<JoystickPage> {
  joystick.StickDragDetails? _stickDragDetails;

  bool _isEnabled = false;
  double _pitch = 0;

  // constructor
  JoystickPageState() {
    TelemetryModel().addListener(() {
      setState(() {
        _pitch = TelemetryModel().telemetryMessage?.pitch ?? 0;
        _isEnabled = TelemetryModel().telemetryMessage?.enabled ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionModel>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Open settings',
              onPressed: () {
                // navigate to config_page
                Navigator.pushNamed(context, '/config');
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    StatusIndicator(connectionStatus: value.status, enabled: _isEnabled),

                    const SizedBox(height: 10),

                    SlideToEnable(enabled: _isEnabled, onStateChange: (value) {
                      setEnabledCommand(value);
                    }),
                  ],
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ModelViewer(
                    // yaw: value.status == ConnectionStatus.connected ? (_stickDragDetails?.x ?? 0) * 45 : 0,
                    // pitch: value.status == ConnectionStatus.connected ? -_pitch : 0
                    yaw: true ? (_stickDragDetails?.x ?? 0) * 45 : 0,
                    pitch: true ? -_pitch : 0

                  ),
                ),

                Joystick(listener: (joystick.StickDragDetails details) {
                  setState(() {
                    _stickDragDetails = details;
                  });

                  setJoystickCommand(details);
                }),
              ],
            ))),
      );
    });
  }
}
