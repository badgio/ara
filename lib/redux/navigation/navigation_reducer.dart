import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/navigation/navigation_actions.dart';
import 'package:redux/redux.dart';

final navReducers = combineReducers<AppState>([
  TypedReducer<AppState, BottomBarIndexUpdateAction>(_updateBottomBarIndex),
]);

AppState _updateBottomBarIndex(
    AppState state, BottomBarIndexUpdateAction action) {
  return AppState(user: state.user, navSelectedIndex: action.newIndex);
}
