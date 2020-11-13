import 'package:ara/models/mobile_user.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final MobileUser user;
  final int navSelectedIndex;

  AppState({this.user, this.navSelectedIndex = 0});

  factory AppState.init() => AppState(user: null, navSelectedIndex: 0);

  @override
  String toString() {
    return 'AppState{user: $user, navSelectedIndex: $navSelectedIndex}';
  }
}
