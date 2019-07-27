import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ursa_ds_mobile/drawer.dart';
import 'package:ursa_ds_mobile/model.dart';
import 'package:ursa_ds_mobile/store/actions.dart';

class SettingsPage extends StatelessWidget {
  void onChanged(bool value) {
    print('updating to $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: NavigationDrawer(),
      body: StoreConnector <AppState, _ViewModel>(
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

