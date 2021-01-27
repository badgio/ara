import 'dart:io';
import 'package:ara/configuration.dart';
import 'package:ara/models/badge.dart';
import 'package:ara/models/collection.dart';
import 'package:ara/repositories/collection_repository.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

List<Middleware<AppState>> createImportDataMiddleware(
  CollectionRepository collectionRepository,
  Map<String, GlobalKey<NavigatorState>> navigatorKeys,
) {
  final importData = _importData(collectionRepository, navigatorKeys);
  return [
    TypedMiddleware<AppState, ImportDataAction>(importData),
  ];
}

Future<dynamic> getData(String path, String token) async {
  final http.Response response = await http.get(
    Configuration.BASE_API_URL + path,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
    },
  );
  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body);
  } else {
    print(response.statusCode);
    return null;
  }
}

String getImage(String image) {
  RegExp exp = new RegExp(r"(.+?,)(.*)");
  Iterable<RegExpMatch> matches = exp.allMatches(image);
  return matches.first.group(2);
}

Middleware<AppState> _importData(
  CollectionRepository repo,
  Map<String, GlobalKey<NavigatorState>> navKey,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    var mUser = FirebaseAuth.instance.currentUser;
    var token = await mUser.getIdToken(true);
    Map<String, Collection> _collections = {};
    Set<Badge> _badges = {};
    //get all Collections
    var col = await getData("/collections?status=APPROVED", token);
    for (var i = 0; i < col.length; i++) {
      var status =
          await getData("/collections/" + col[i]['uuid'] + "/status", token);
      _collections.putIfAbsent(
          col[i]['uuid'],
          () => Collection(
                id: col[i]['uuid'],
                name: col[i]['name'],
                image: getImage(col[i]['image']),
                description: col[i]['description'],
                badges: {},
                startDate: DateTime.parse(col[i]['start_date']),
                endDate: col[i]['end_date'] != null
                    ? DateTime.parse(col[i]['end_date'])
                    : null,
                status: status['collection_status'].toDouble(),
                redeemedBadges: status['collected_badges'].cast<String>(),
                reward: col[i]['reward'],
              ));
    }
    //get All badges
    var badges = await getData("/badges?status=APPROVED", token);
    for (var i = 0; i < badges.length; i++) {
      var badgeCol =
          await getData("/collections?badge=" + badges[i]['uuid'], token);
      Set<Collection> collec = {};
      for (int i = 0; i < badgeCol.length; i++) {
        collec.add(Collection(
          id: badgeCol[i]['uuid'],
          image: getImage(badgeCol[i]['image']),
        ));
      }
      var red = false;
      if (badgeCol.length == 0) {
        continue;
      }
      if (_collections[badgeCol[0]['uuid']].redeemedBadges.isNotEmpty) {
        red = _collections[badgeCol[0]['uuid']]
            .redeemedBadges
            .contains(badges[i]['uuid']);
      }
      var location = await getData("/locations?uuid=" + badges[i]['location'], token);
      var badge = Badge(
        id: badges[i]['uuid'],
        description: badges[i]['description'],
        name: badges[i]['name'],
        image: getImage(badges[i]['image']),
        redeemed: red,
        collections: collec,
        lat: location[0]['latitude'],
        lng: location[0]['longitude'],
      );
      for (var u = 0; u < badgeCol.length; u++) {
        var collection = _collections[badgeCol[u]['uuid']];
        if (_collections.containsKey(badgeCol[u]['uuid'])) {
          collection.badges.add(badge);
        }
        _badges.add(badge);
      }
    }
    //get time Limited
    String end = new DateTime(
            DateTime.now().year,
            DateTime.now().month + 1,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second)
        .toIso8601String();
    var endDate = Uri.encodeComponent(end);
    List<dynamic> tl =
        await getData("/collections/?end_date__lt=" + endDate, token);
    Set<Collection> timeLimited = {};
    for (var i = 0; i < tl.length; i++) {
      timeLimited.add(_collections[tl[i]['uuid']]);
    }
    repo.addCollections(_collections.values.toSet());
    repo.addBadges(_badges);
    repo.addTimeLimited(timeLimited);

    final cols = LoadCollectionsAction();
    final bs = LoadBadgesAction();

    store.dispatch(cols);
    store.dispatch(bs);
  };
}

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
    var col = await repo.getAllCollections();
    var timeLimited = await repo.getTimeLimited();
    if (timeLimited == null) timeLimited = {};
    await store.dispatch(
        CollectionsLoadedAction(collections: col, timeLimited: timeLimited));
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
    var bs = await repo.getAllBadges();
    await store.dispatch(BadgesLoadedAction(badges: bs));
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
