import 'package:ursa_ds_mobile/domain/incomingMessage.dart';
import 'package:ursa_ds_mobile/model.dart';

class SetControlMode {
  final ControlMode controlMode;

  SetControlMode(this.controlMode);
}

class SetMessageData {
  final IncomingMessage incomingMessage;

  SetMessageData(this.incomingMessage);
}

class SetConnectionStatus {
  final bool connected;

  SetConnectionStatus(this.connected);
}
