import 'dart:convert';
import 'dart:io';
import 'package:ara/models/collection.dart';
import 'package:ara/redux/redeem/redeem_actions.dart';
import 'package:http/http.dart' as http;
import 'package:ara/models/badge.dart';
import 'package:ara/repositories/collection_repository.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/redux/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:redux/redux.dart';
import 'dart:convert' as convert;
import 'package:ara/configuration.dart';

List<Middleware<AppState>> createRedeemMiddleware(
  CollectionRepository collectionRepository,
  Map<String, GlobalKey<NavigatorState>> navigatorKeys,
) {
  final redeem = _createRedeemMiddleware(collectionRepository, navigatorKeys);
  return [
    TypedMiddleware<AppState, RedeemTagAction>(redeem),
  ];
}

Middleware<AppState> _createRedeemMiddleware(
  CollectionRepository collectionRep,
  Map<String, GlobalKey<NavigatorState>> navigatorKeys,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      for (NDEFRecord record in action.message.records) {
        //token
        User mUser = FirebaseAuth.instance.currentUser;
        mUser.getIdToken(true).then((token) => {
              getBadges(token, record.data, action, navigatorKeys, store,
                  collectionRep)
            });
      }
    } on Exception catch (e) {
      action.completer.completeError(e);
      print("Error signin up: $e");
    }
    return null;
  };
}

RegExpMatch getMatch(record) {
  RegExp exp = new RegExp(
    r"uid=(\w+)&ctr=(\w+)&c=(\w+)",
    caseSensitive: false,
    multiLine: false,
  );
  var matches = exp.allMatches(record);
  if (matches == null) {
    return null;
  } else {
    return matches.elementAt(0);
  }
}

Future getBadges(
  String token,
  String data,
  action,
  navigatorKey,
  Store store,
  CollectionRepository collectionRep,
) async {
  var match = getMatch(data);
  if (match == null) {
    return ("ERROR");
  }
  final http.Response response = await http.post(
    Configuration.BASE_API_URL + "/badges/redeem",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
    },
    body: jsonEncode(<String, String>{
      'uid': match.group(1),
      'counter': match.group(2),
      'cmac': match.group(3),
    }),
  );
  if (response.statusCode == 200) {
    List<dynamic> res = convert.jsonDecode(response.body);
    if (res.isEmpty) {
      action.completer.completeError("This bagde has already been redeemed!");
      //This bagde has already been redeemed!
    }
    for (var i = 0; i < res.length; i++) {
      var oldBadge = await collectionRep.getBadge(res[i]['uuid']);
      Badge badge = Badge(
          id: res[i]['uuid'],
          name: res[i]['name'],
          image: res[i]['image'].substring(22),
          description: res[i]['description'],
          redeemed: true,
          collections: oldBadge.collections);
      oldBadge.collections.forEach((id) async {
        Collection collection = await collectionRep.getCollection(id);
        print(collection.toString());
        collection.updateBadges(badge);
        collection.redeemedBadges.add(badge.id);
        collection.status =
            (collection.redeemedBadges.length) / (collection.badges.length);
        collectionRep.updateCollection(collection);
      });
      collectionRep.updateBadge(badge);
      store.dispatch(OpenBadgeAction(badgeId: res[i]['uuid']));
      action.completer.complete();
    }
  }
  if (response.statusCode == 410) {
    //counter já foi utilizado
    print("410");
    action.completer.completeError("Error redeeming the badge");
  }
  if (response.statusCode == 406) {
    //CMAC está mal"
    print("406");
    action.completer.completeError("Error redeeming the badge");
  }
  if (response.statusCode == 400 || response.statusCode == 500) {
    action.completer.completeError("Error redeeming the badge");
    print(response.statusCode);
  }
}
