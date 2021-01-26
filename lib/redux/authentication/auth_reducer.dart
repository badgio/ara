import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:redux/redux.dart';

final authReducers = combineReducers<AppState>([
  TypedReducer<AppState, SignInSuccessAction>(_signIn),
]);

AppState _signIn(AppState state, SignInSuccessAction action) {
  return AppState(
    user: action.user,
    selectedBadge: state.selectedBadge,
    selectedCollections: state.selectedCollections,
    selectedBadges: state.selectedBadges,
    timeLimited: state.timeLimited,
    selectedUser: state.selectedUser,
  );
}

final profReducers = combineReducers<AppState>([
  TypedReducer<AppState, ProfileLoadedAction>(_openProfile),
]);

AppState _openProfile(AppState state, ProfileLoadedAction action) {
  return AppState(
    navSelectedIndex: state.navSelectedIndex,
    user: state.user,
    selectedUser: action.user,
    selectedBadges: state.selectedBadges,
  );
}