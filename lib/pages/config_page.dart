import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../domain/connection.dart';
import '../domain/dtos/telemetry_message.dart';
import '../models/telemetry_model.dart';

class ConfigParameter {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;

  ConfigParameter({
    required this.label,
    required this.controller,
    required this.focusNode,
  });
}

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  ConfigPageState createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  List<ConfigParameter> _angleParameters = [];
  List<ConfigParameter> _speedParameters = [];

  bool hasData = true;

  ConfigPageState() {
    _telemetryListener(useSetState: false);

    _angleParameters = ['Angle P', 'Angle I', 'Angle D']
        .map(
          (e) => ConfigParameter(
            label: e,
            controller: TextEditingController(),
            focusNode: FocusNode(),
          ),
        )
        .toList();

    _speedParameters = ['Speed P', 'Speed I', 'Speed D']
        .map(
          (e) => ConfigParameter(
            label: e,
            controller: TextEditingController(),
            focusNode: FocusNode(),
          ),
        )
        .toList();

    // Set up listeners for focus events
    for (var element in [..._angleParameters, ..._speedParameters]) {
      element.focusNode.addListener(() {
        if (!element.focusNode.hasFocus) {
          _onBlur();
        }
      });
    }
  }

  Widget _buildConfigSection(List<ConfigParameter> parameters, String title) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ...parameters
            .map(
              (e) => TextField(
                controller: e.controller,
                decoration: InputDecoration(
                  labelText: e.label,
                ),
                keyboardType: TextInputType.number,
                enabled: hasData,
                focusNode: e.focusNode,
              ),
            )
            .toList(),
      ],
    );
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
              _buildConfigSection(
                _angleParameters,
                AppLocalizations.of(context)!.angleConfig,
              ),

              // 20px spacer
              const SizedBox(height: 20),

              _buildConfigSection(
                _speedParameters,
                AppLocalizations.of(context)!.speedConfig,
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
          ),
        ),
      ),
    );
  }

  void _onBlur() {
    List<double> angleValues = _angleParameters
        .map((parameter) => _getParsedValue(parameter.controller.text))
        .toList();
    List<double> speedValues = _speedParameters
        .map((parameter) => _getParsedValue(parameter.controller.text))
        .toList();

    setPidCommand(
      angleValues[0],
      angleValues[1],
      angleValues[2],
      speedValues[0],
      speedValues[1],
      speedValues[2],
      save: false,
    );
  }

  void _saveConfig(BuildContext context) {
    List<double> angleValues = _angleParameters
        .map((parameter) => _getParsedValue(parameter.controller.text))
        .toList();
    List<double> speedValues = _speedParameters
        .map((parameter) => _getParsedValue(parameter.controller.text))
        .toList();

    setPidCommand(
      angleValues[0],
      angleValues[1],
      angleValues[2],
      speedValues[0],
      speedValues[1],
      speedValues[2],
      save: true,
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
      _angleParameters[0].controller.text =
          num.parse(message.angleP.toStringAsFixed(6)).toString();
      _angleParameters[1].controller.text =
          num.parse(message.angleI.toStringAsFixed(6)).toString();
      _angleParameters[2].controller.text =
          num.parse(message.angleD.toStringAsFixed(6)).toString();

      _speedParameters[0].controller.text =
          num.parse(message.speedP.toStringAsFixed(6)).toString();
      _speedParameters[1].controller.text =
          num.parse(message.speedI.toStringAsFixed(6)).toString();
      _speedParameters[2].controller.text =
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

  double _getParsedValue(String text) {
    return double.tryParse(text) ?? 0.0;
  }
}
