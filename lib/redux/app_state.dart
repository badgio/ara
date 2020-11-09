import 'package:ara/models/mobile_user.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final MobileUser user;

  AppState({this.user});

  factory AppState.init() => AppState(user: null);

  @override
  String toString() {
    return 'AppState{user: $user}';
  }
}
