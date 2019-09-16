import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ursa_ds_mobile/domain/communications.dart';
import 'package:ursa_ds_mobile/drawer.dart';
import 'package:ursa_ds_mobile/model.dart';
import 'package:ursa_ds_mobile/store/actions.dart';
import 'package:ursa_ds_mobile/store/store.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  double speedP = store.state.incomingMessage.speedP;
  double speedI = store.state.incomingMessage.speedI;
  double speedD = store.state.incomingMessage.speedD;

  double angleP = store.state.incomingMessage.angleP;
  double angleI = store.state.incomingMessage.angleI;
  double angleD = store.state.incomingMessage.angleD;

  void onChangeSpeedP(double value) {
    message.speedP = value;
    message.saveRecallState = 2;

    setState(() {
      speedP = value;
    });
  }

  void onChangeSpeedI(double value) {
    message.speedI = value;
    message.saveRecallState = 2;

    setState(() {
      speedI = value;
    });
  }

  void onChangeSpeedD(double value) {
    message.speedD = value;
    message.saveRecallState = 2;

    setState(() {
      speedD = value;
    });
  }

  void onChangeAngleP(double value) {
    message.angleP = value;
    message.saveRecallState = 2;

    setState(() {
      angleP = value;
    });
  }

  void onChangeAngleI(double value) {
    message.angleI = value;
    message.saveRecallState = 2;

    setState(() {
      angleI = value;
    });
  }

  void onChangeAngleD(double value) {
    message.angleD = value;
    message.saveRecallState = 2;

    setState(() {
      angleD = value;
    });
  }

  Widget slider(double value, ValueChanged<double> onChanged, String label) {
    TextEditingController controller =
    TextEditingController(text: value.toStringAsFixed(3));

    return Container(
        padding: EdgeInsets.only(right: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              flex: 4,
              child: Slider(value: value, onChanged: onChanged),
            ),
            Flexible(
              flex: 1,
              child: TextField(
                controller: controller,
                onSubmitted: (String value) { onChanged(double.parse(value)); },
                decoration: InputDecoration(labelText: label),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: NavigationDrawer(),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (context, _ViewModel viewModel) => ListView(
          children: [
            ListTile(
              title: Text('Control Mode'),
              trailing: DropdownButton<ControlMode>(
                value: viewModel.controlMode,
                items: ControlMode.values.map((mode) {
                  return DropdownMenuItem<ControlMode>(
                    value: mode,
                    child: Text(mode.toString().replaceFirst('ControlMode.', '')),
                  );
                }).toList(),
                onChanged: viewModel.onChangeControlMode,
              ),
            ),
            ListTile(
              title: Text('Some other setting'),
              trailing: Checkbox(value: false, onChanged: (_) {}),
            ),
            ListTile(
              title: Text('Yet another setting'),
              trailing: Container(
                width: 150,
                child: TextField(
                  controller: TextEditingController(text: '127.0.0.1'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp('[0-9\.]'))
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Divider(),
            ),
            slider(speedP, onChangeSpeedP, "Speed P"),
            slider(speedI, onChangeSpeedI, "Speed I"),
            slider(speedD, onChangeSpeedD, "Speed D"),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Divider(),
            ),
            slider(angleP, onChangeAngleP, "Angle P"),
            slider(angleI, onChangeAngleI, "Angle I"),
            slider(angleD, onChangeAngleD, "Angle D"),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final ControlMode controlMode;
  final Function(ControlMode) onChangeControlMode;

  _ViewModel({
    this.controlMode,
    this.onChangeControlMode,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onChangeControlMode(ControlMode controlMode) {
      store.dispatch(SetControlMode(controlMode));
    }

    return _ViewModel(
      controlMode: store.state.controlMode,
      onChangeControlMode: _onChangeControlMode,
    );
  }
}

