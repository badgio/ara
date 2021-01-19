import 'dart:async';
import 'package:ara/models/badge.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class RedeemTagAction {
  final NDEFMessage message;
  final Completer completer;

  RedeemTagAction({
    this.message,
    Completer completer,
  }) : completer = completer ?? Completer();

  @override
  String toString() {
    return 'RedeemTag{message: $message}';
  }
}

class RedeemSuccessAction {
  final Badge badge;

  RedeemSuccessAction({@required this.badge});

  @override
  String toString() {
    return 'RedeemSucessAction{badge: $badge}';
  }
}
