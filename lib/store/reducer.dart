import 'package:ursa_ds_mobile/model.dart';
import 'package:ursa_ds_mobile/store/actions.dart';

AppState appStateReducer(AppState state, action) {
  switch(action.runtimeType) {
    case SetControlMode:
      return AppState(
        controlMode: action.controlMode,
        incomingMessage: state.incomingMessage,
        connected: state.connected,
      );
    case SetMessageData:
      return AppState(
        controlMode: state.controlMode,
        incomingMessage: action.incomingMessage,
        connected: state.connected,
      );
    case SetConnectionStatus:
      return AppState(
        controlMode: state.controlMode,
        incomingMessage: state.incomingMessage,
        connected: action.connected,
      );
  }

  return state;
}
