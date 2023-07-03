import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../domain/connection.dart';
import '../domain/dtos/telemetry_message.dart';
import '../models/telemetry_model.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  ConfigPageState createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  final TextEditingController _anglePController = TextEditingController();
  final TextEditingController _angleIController = TextEditingController();
  final TextEditingController _angleDController = TextEditingController();

  final TextEditingController _speedPController = TextEditingController();
  final TextEditingController _speedIController = TextEditingController();
  final TextEditingController _speedDController = TextEditingController();

  bool hasData = false;

  ConfigPageState() {
    _telemetryListener(useSetState: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.config),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Text(AppLocalizations.of(context)!.angleConfig,
                        style: Theme.of(context).textTheme.headlineSmall),
                    TextField(
                      controller: _anglePController,
                      decoration: const InputDecoration(
                        labelText: "Angle P",
                      ),
                      keyboardType: TextInputType.number,
                      enabled: hasData,
                    ),
                    TextField(
                      controller: _angleIController,
                      decoration: const InputDecoration(
                        labelText: "Angle I",
                      ),
                      keyboardType: TextInputType.number,
                      enabled: hasData,
                    ),
                    TextField(
                      controller: _angleDController,
                      decoration: const InputDecoration(
                        labelText: "Angle D",
                      ),
                      keyboardType: TextInputType.number,
                      enabled: hasData,
                    ),

                    // 20px spacer
                    const SizedBox(height: 20),

                    Text(AppLocalizations.of(context)!.speedConfig,
                        style: Theme.of(context).textTheme.headlineSmall),
                    TextField(
                      controller: _speedPController,
                      decoration: const InputDecoration(
                        labelText: "Angle P",
                      ),
                      keyboardType: TextInputType.number,
                      enabled: hasData,
                    ),
                    TextField(
                      controller: _speedIController,
                      decoration: const InputDecoration(
                        labelText: "Angle I",
                      ),
                      keyboardType: TextInputType.number,
                      enabled: hasData,
                    ),
                    TextField(
                      controller: _speedDController,
                      decoration: const InputDecoration(
                        labelText: "Angle D",
                      ),
                      keyboardType: TextInputType.number,
                      enabled: hasData,
                    ),

                    // 20px spacer
                    const SizedBox(height: 20),

                    // save button
                    ElevatedButton(
                      onPressed: hasData
                          ? () {
                              _saveConfig(context);
                            }
                          : null,
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ))));
  }

  void _saveConfig(BuildContext context) {
    setPidCommand(
      double.parse(_anglePController.text),
      double.parse(_angleIController.text),
      double.parse(_angleDController.text),
      double.parse(_speedPController.text),
      double.parse(_speedIController.text),
      double.parse(_speedDController.text),
    );

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.saveSuccess),
      ),
    );

    // wait 100ms for message to send
    Future.delayed(const Duration(milliseconds: 100), () {
      // listen to next telemetry message
      TelemetryModel().addListener(_telemetryListener);
    });
  }

  void _telemetryListener({bool useSetState = true}) {
    TelemetryMessage? message = TelemetryModel().telemetryMessage;
    if (message != null && message.containsPid) {
      _anglePController.text =
          num.parse(message.angleP.toStringAsFixed(6)).toString();
      _angleIController.text =
          num.parse(message.angleI.toStringAsFixed(6)).toString();
      _angleDController.text =
          num.parse(message.angleD.toStringAsFixed(6)).toString();

      _speedPController.text =
          num.parse(message.speedP.toStringAsFixed(6)).toString();
      _speedIController.text =
          num.parse(message.speedI.toStringAsFixed(6)).toString();
      _speedDController.text =
          num.parse(message.speedD.toStringAsFixed(6)).toString();

      if (useSetState) {
        setState(() {
          hasData = true;
        });
      } else {
        hasData = true;
      }

      // Remove self
      TelemetryModel().removeListener(_telemetryListener);
    }
  }
}
