import 'dart:convert';
import 'package:ara/configuration.dart';
import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:ara/redux/collections/collections_actions.dart';
import 'package:ara/repositories/user_repository.dart';
import 'package:ara/routes.dart';
import 'package:ara/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

List<Middleware<AppState>> createAuthMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  final signIn = _createSignInMiddleware(userRepository, navigatorKey);
  final verifyAuthState =
      _createVerifyAuthStateMiddleware(userRepository, navigatorKey);
  final signOut = _createSignOutMiddleware();
  final signUp = _createSignUpMiddleware(userRepository, navigatorKey);
  final startSignUp = _createStartSignUpMiddleware(navigatorKey);

  return [
    TypedMiddleware<AppState, SignInAction>(signIn),
    TypedMiddleware<AppState, VerifyAuthenticationStateAction>(verifyAuthState),
    TypedMiddleware<AppState, SignOutAction>(signOut),
    TypedMiddleware<AppState, SignUpAction>(signUp),
    TypedMiddleware<AppState, StartSignUpAction>(startSignUp),
  ];
}

Middleware<AppState> _createSignInMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      final user = await userRepository.signIn(action.email, action.password);
      await store.dispatch(ImportDataAction());
      store.dispatch(SignInSuccessAction(user: user));
      await navigatorKey.currentState.pushReplacementNamed(Routes.home);
      action.completer.complete();
    } on Exception catch (e) {
      action.completer.completeError(e);
      print("Error signing in: $e");
    }
  };
}

Middleware<AppState> _createVerifyAuthStateMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    userRepository.getAuthenticationStateChange().listen((user) {
      if (user == null) {
        navigatorKey.currentState.pushReplacementNamed(Routes.signIn);
      } else {
        store.dispatch(SignInSuccessAction(user: user));
      }
    });
  };
}

// TODO
Middleware<AppState> _createSignOutMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
  };
}

Middleware<AppState> _createSignUpMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      print(action.toString());
      Map<String, String> body = {};
      body["email"] = action.email;
      body["password"] = action.password;
      if (action.name != null) {
        body["name"] = action.name;
      }
      if (action.birthDate != null) {
        body["date_birth"] = action.birthDate;
      }
      if (action.gender != null) {
        body["gender"] = action.gender;
      }
      if (action.country != null) {
        body["country"] = action.country;
      }
      if (action.city != null) {
        body["city"] = action.city;
      }
      http
          .post(
        Configuration.BASE_API_URL + "/users/mobile",
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(body),
      )
          .then(
        (response) async {
          if (response.statusCode == 201) {
            // if could create user, signIn to firebase
            final user =
                await userRepository.signIn(action.email, action.password);
            await store.dispatch(ImportDataAction());
            store.dispatch(SignInSuccessAction(user: user));
            await navigatorKey.currentState.pushReplacementNamed(Routes.home);
            action.completer.complete();
          } else {
            print("SignUpError: " +
                response.statusCode.toString() +
                " > " +
                response.reasonPhrase);
            action.completer.completeError(response.reasonPhrase);
          }
        },
      );
    } on Exception catch (e) {
      action.completer.completeError(e);
      print("Error signin up: $e");
    }
  };
}

Middleware<AppState> _createStartSignUpMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    await navigatorKey.currentState.pushReplacementNamed(Routes.signUp);
  };
}
