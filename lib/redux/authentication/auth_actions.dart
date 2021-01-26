import 'package:ara/models/info_user.dart';
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

class SignUpAction {
  final String email;
  final String password;
  final String name;
  final String birthDate;
  final String country;
  final String city;
  final String gender;
  final Completer completer;

  SignUpAction({
    this.email,
    this.password,
    this.name,
    this.birthDate,
    this.country,
    this.city,
    this.gender,
    completer,
  }) : completer = completer ?? Completer();

  @override
  String toString() {
    return 'SignUp{email: $email, password: $password, name: $name, birthDate: $birthDate, country: $country, city: $city, gender: $gender}';
  }
}

class StartSignUpAction {
  final String email;
  final String password;

  StartSignUpAction({
    this.email,
    this.password,
  });

  @override
  String toString() {
    return 'StartSignUp{email: $email, password: $password';
  }
}

class SignOutAction {}

class SignOutSuccessAction {}

class LoadProfileAction {
  const LoadProfileAction();

  @override
  String toString() {
    return "OpenProfileAction";
  }
}

class ProfileLoadedAction {
  final InfoUser user;

  const ProfileLoadedAction({this.user});


  @override
  String toString() {
    return "ProfileLoadedAction{user: $user}";
  }
}
