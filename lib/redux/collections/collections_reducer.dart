import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:redux/redux.dart';

final colReducers = combineReducers<AppState>([
  TypedReducer<AppState, CollectionLoadedAction>(_openCollection),
]);

AppState _openCollection(AppState state, CollectionLoadedAction action) {
  return AppState(
    navSelectedIndex: state.navSelectedIndex,
    user: state.user,
    selectedBadge: state.selectedBadge,
    selectedCollection: action.collection,
  );
}

final bReducers = combineReducers<AppState>([
  TypedReducer<AppState, BadgeLoadedAction>(_openBadge),
]);

AppState _openBadge(AppState state, BadgeLoadedAction action) {
  return AppState(
    navSelectedIndex: state.navSelectedIndex,
    user: state.user,
    selectedBadge: action.badge,
    selectedCollection: state.selectedCollection,
  );
}
