import 'package:ara/models/mobile_user.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class VerifyAuthenticationStateAction {}

class SignInAction {
  final String email;
  final String password;
  final Completer completer;

  SignInAction({this.email, this.password, Completer completer})
      : completer = completer ?? Completer();

  @override
  String toString() {
    return 'SignIn{email: $email, password: $password}';
  }
}

class SignInSuccessAction {
  final MobileUser user;

  SignInSuccessAction({@required this.user});

  @override
  String toString() {
    return 'SignInSuccess{user: $user}';
  }
}

class SignInFailureAction {
  final String error;

  SignInFailureAction(this.error);

  @override
  String toString() {
    return 'SignIn{Error during sign-in: $error}';
  }
}

class SignOutAction {}

class SignOutSuccessAction {}
