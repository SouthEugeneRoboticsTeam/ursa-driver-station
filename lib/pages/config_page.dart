import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/config_model.dart';
import '../models/desired_state_model.dart';
import '../models/robot_state_model.dart';

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

  String packageVersion = '';

  ConfigPageState() {
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

    _robotStateListener(useSetState: false);

    PackageInfo.fromPlatform()
        .then((value) => setState(() => packageVersion = value.version));

    // Set up listeners for focus events
    for (var element in [..._angleParameters, ..._speedParameters]) {
      element.focusNode.addListener(() {
        if (!element.focusNode.hasFocus) {
          _onBlur();
        }
      });
    }
  }

  Widget _buildPidSection(List<ConfigParameter> parameters, String title) {
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

  Widget _buildLimitSection(
    String title,
    double value,
    void Function(double) onChange,
  ) {
    var controller = TextEditingController(text: value.toStringAsFixed(2));
    var focusNode = FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        onChange(_getParsedValue(controller.text).clamp(0, 1));
      }
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 150,
          child: TextField(
            decoration: InputDecoration(labelText: title),
            keyboardType: TextInputType.number,
            enabled: hasData,
            controller: controller,
            focusNode: focusNode,
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            onChanged: (e) => onChange(
              e.clamp(0, 1),
            ),
          ),
        ),
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
            shrinkWrap: true,
            children: [
              Text(
                'App version: $packageVersion',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              _buildPidSection(
                _angleParameters,
                AppLocalizations.of(context)!.angleConfig,
              ),
              const SizedBox(height: 20),
              _buildPidSection(
                _speedParameters,
                AppLocalizations.of(context)!.speedConfig,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: hasData
                    ? () {
                        _saveConfig(context);
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.save),
              ),
              const SizedBox(height: 50),
              Text(
                AppLocalizations.of(context)!.limits,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              _buildLimitSection(
                AppLocalizations.of(context)!.speedLimit,
                ConfigModel().speedScalar,
                (e) {
                  setState(() {
                    ConfigModel().setSpeedScalar(e);
                  });
                },
              ),
              _buildLimitSection(
                AppLocalizations.of(context)!.turnLimit,
                ConfigModel().turnScalar,
                (e) {
                  setState(() {
                    ConfigModel().setTurnScalar(e);
                  });
                },
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

    DesiredStateModel().setPid(
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

    DesiredStateModel().setPid(
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
      RobotStateModel().addListener(_robotStateListener);
    });
  }

  void _robotStateListener({bool useSetState = true}) {
    RobotStateModel robotState = RobotStateModel();

    if (robotState.containsPid == true) {
      _angleParameters[0].controller.text =
          num.parse(robotState.angleP!.toStringAsFixed(6)).toString();
      _angleParameters[1].controller.text =
          num.parse(robotState.angleI!.toStringAsFixed(6)).toString();
      _angleParameters[2].controller.text =
          num.parse(robotState.angleD!.toStringAsFixed(6)).toString();

      _speedParameters[0].controller.text =
          num.parse(robotState.speedP!.toStringAsFixed(6)).toString();
      _speedParameters[1].controller.text =
          num.parse(robotState.speedI!.toStringAsFixed(6)).toString();
      _speedParameters[2].controller.text =
          num.parse(robotState.speedD!.toStringAsFixed(6)).toString();

      if (useSetState) {
        setState(() {
          hasData = true;
        });
      } else {
        hasData = true;
      }

      // Remove self
      RobotStateModel().removeListener(_robotStateListener);
    }
  }

  double _getParsedValue(String text) {
    return double.tryParse(text) ?? 0.0;
  }
}
