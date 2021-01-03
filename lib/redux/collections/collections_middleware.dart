import 'package:ara/repositories/collection_repository.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/routes.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createCollectionsMiddleware(
  CollectionRepository collectionRepository,
  Map<String, GlobalKey<NavigatorState>> navigatorKeys,
) {
  final loadAll = _loadCollections(collectionRepository, navigatorKeys);
  final openCollection = _openCollection(collectionRepository, navigatorKeys);
  return [
    TypedMiddleware<AppState, LoadCollectionsAction>(loadAll),
    TypedMiddleware<AppState, OpenCollectionAction>(openCollection),
  ];
}

Middleware<AppState> _loadCollections(
  CollectionRepository repo,
  Map<String, GlobalKey<NavigatorState>> navKey,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    return null;
  };
}

Middleware<AppState> _openCollection(
  CollectionRepository repo,
  Map<String, GlobalKey<NavigatorState>> navKey,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    repo.getCollection(action.collectionId).then((c) {
      store.dispatch(CollectionLoadedAction(collection: c));
      navKey[Routes.getTabRouteByIndex(store.state.navSelectedIndex)]
          .currentState
          .pushNamed(Routes.collection);
    });
  };
}

List<Middleware<AppState>> createBadgesMiddleware(
    CollectionRepository collectionRepository,
    Map<String, GlobalKey<NavigatorState>> navigatorKeys,
    ) {
  final loadAll = _loadBadges(collectionRepository, navigatorKeys);
  final openBadge = _openBadge(collectionRepository, navigatorKeys);
  return [
    TypedMiddleware<AppState, LoadBadgesAction>(loadAll),
    TypedMiddleware<AppState, OpenBadgeAction>(openBadge),
  ];
}

Middleware<AppState> _loadBadges(
    CollectionRepository repo,
    Map<String, GlobalKey<NavigatorState>> navKey,
    ) {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    return null;
  };
}

Middleware<AppState> _openBadge(
    CollectionRepository repo,
    Map<String, GlobalKey<NavigatorState>> navKey,
    ) {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    repo.getBadge(action.badgeId).then((badge) {
      store.dispatch(BadgeLoadedAction(badge: badge));
      navKey[Routes.getTabRouteByIndex(store.state.navSelectedIndex)]
          .currentState
          .pushNamed(Routes.badge);
    });
  };
}
