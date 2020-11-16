import 'package:ara/models/collection.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final MobileUser user;
  final int navSelectedIndex;
  final Collection selectedCollection;

  AppState({
    this.user,
    this.navSelectedIndex = 0,
    this.selectedCollection,
  });

  factory AppState.init() => AppState(
        user: null,
        navSelectedIndex: 0,
        selectedCollection: null,
      );

  @override
  String toString() {
    return 'AppState{user: $user, navSelectedIndex: $navSelectedIndex, selectedCollection: $selectedCollection}';
  }
}
