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
    selectedCollection: action.collection,
  );
}
