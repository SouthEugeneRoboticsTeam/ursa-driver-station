import 'package:flutter/material.dart';
import 'package:ursa_ds_mobile/domain/dtos/telemetry_message.dart';

class TelemetryModel extends ChangeNotifier {
  static final TelemetryModel _instance = TelemetryModel._internal();

  factory TelemetryModel() {
    return _instance;
  }

  TelemetryModel._internal();

  TelemetryMessage? _telemetryMessage;

  TelemetryMessage? get telemetryMessage => _telemetryMessage;

  void setTelemetry(TelemetryMessage value) {
    _telemetryMessage = value;

    notifyListeners();
  }
}
