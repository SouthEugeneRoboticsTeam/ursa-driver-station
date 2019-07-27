import 'package:ursa_ds_mobile/model.dart';

ControlMode changeControlMode(ControlMode state, action) {
  return action.controlMode;
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    controlMode: changeControlMode(state.controlMode, action),
  );
}
