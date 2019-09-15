import 'package:redux/redux.dart';
import 'package:ursa_ds_mobile/model.dart';
import 'package:ursa_ds_mobile/store/reducer.dart';

final Store store = Store<AppState>(
  appStateReducer,
  initialState: AppState.initialState(),
);
