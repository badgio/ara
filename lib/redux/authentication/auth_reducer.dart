import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:redux/redux.dart';

final authReducers = combineReducers<AppState>([
  TypedReducer<AppState, SignInSuccessAction>(_signIn),
]);

AppState _signIn(AppState state, SignInSuccessAction action) {
  return AppState(user: state.user);
}
