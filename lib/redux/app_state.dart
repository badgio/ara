import 'package:ara/models/collection.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:ara/models/badge.dart';
import 'package:flutter/foundation.dart';
import 'package:ara/models/info_user.dart';

@immutable
class AppState {
  final MobileUser user;
  final int navSelectedIndex;
  final Collection selectedCollection;
  final Badge selectedBadge;
  final Set<Badge> selectedBadges;
  final Set<Collection> selectedCollections;
  final Set<Collection> timeLimited;
  final InfoUser selectedUser;

  AppState({
    this.user,
    this.navSelectedIndex = 0,
    this.selectedCollection,
    this.selectedBadge,
    this.selectedBadges,
    this.selectedCollections,
    this.timeLimited,
    this.selectedUser,
  });

  factory AppState.init() => AppState(
      user: null,
      navSelectedIndex: 0,
      selectedCollection: new Collection(),
      selectedBadge: new Badge(),
      selectedBadges: {},
      selectedCollections: {},
      timeLimited: {},
      selectedUser: null,
  );

  @override
  String toString() {
    return 'AppState{user: $user, navSelectedIndex: $navSelectedIndex, selectedCollection: $selectedCollection, selectedBadge: $selectedBadge, selectedUser: $selectedUser}';
  }
}
