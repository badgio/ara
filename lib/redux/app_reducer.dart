import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/authentication/auth_reducer.dart';
import 'package:ara/redux/collections/collections_reducer.dart';
import 'package:ara/redux/navigation/navigation_reducer.dart';
import 'package:redux/redux.dart';

final appReducer = combineReducers<AppState>([
  authReducers,
  navReducers,
  colReducers,
]);
