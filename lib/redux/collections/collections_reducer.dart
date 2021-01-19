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
    selectedCollections: state.selectedCollections,
    selectedBadge: state.selectedBadge,
    timeLimited: state.timeLimited,
  );
}

final collectionsReducers = combineReducers<AppState>([
  TypedReducer<AppState, CollectionsLoadedAction>(_loadedCollections),
]);

AppState _loadedCollections(AppState state, CollectionsLoadedAction action) {
  return AppState(
    navSelectedIndex: state.navSelectedIndex,
    user: state.user,
    selectedCollection: state.selectedCollection,
    selectedCollections: action.collections,
    selectedBadge: state.selectedBadge,
    timeLimited: action.timeLimited,
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
    selectedCollections: state.selectedCollections,
    timeLimited: state.timeLimited,
  );
}
