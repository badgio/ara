import 'package:ara/models/collection.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:ara/models/badge.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final MobileUser user;
  final int navSelectedIndex;
  final Collection selectedCollection;
  final Badge selectedBadge;

  AppState({
    this.user,
    this.navSelectedIndex = 0,
    this.selectedCollection,
    this.selectedBadge,
  });

  factory AppState.init() => AppState(
        user: null,
        navSelectedIndex: 0,
        selectedCollection: new Collection(),
        selectedBadge: new Badge(),
      );

  @override
  String toString() {
    return 'AppState{user: $user, navSelectedIndex: $navSelectedIndex, selectedCollection: $selectedCollection, selectedBadge: $selectedBadge}';
  }
}
