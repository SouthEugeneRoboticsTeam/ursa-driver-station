import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigModel extends ChangeNotifier {
  static final ConfigModel _instance = ConfigModel._internal();

  factory ConfigModel() {
    _instance._initState();

    return _instance;
  }

  Future _initState() async {
    prefs = await SharedPreferences.getInstance();

    double speedScalar = prefs?.getDouble('ConfigModel.speedScalar') ?? 1.0;
    double turnScalar = prefs?.getDouble('ConfigModel.turnScalar') ?? 1.0;

    setSpeedScalar(speedScalar);
    setTurnScalar(turnScalar);
  }

  ConfigModel._internal();

  SharedPreferences? prefs;

  double speedScalar = 1.0;
  double turnScalar = 1.0;

  void setSpeedScalar(double value) {
    speedScalar = value;
    prefs?.setDouble('ConfigModel.speedScalar', value);

    notifyListeners();
  }

  void setTurnScalar(double value) {
    turnScalar = value;
    prefs?.setDouble('ConfigModel.turnScalar', value);

    notifyListeners();
  }
}
