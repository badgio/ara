import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:ara/repositories/user_repository.dart';
import 'package:ara/routes.dart';
import 'package:ara/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAuthMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  final signIn = _createSignInMiddleware(userRepository, navigatorKey);
  final verifyAuthState =
      _createVerifyAuthStateMiddleware(userRepository, navigatorKey);
  final signOut = _createSignOutMiddleware();

  return [
    TypedMiddleware<AppState, SignInAction>(signIn),
    TypedMiddleware<AppState, VerifyAuthenticationStateAction>(verifyAuthState),
    TypedMiddleware<AppState, SignOutAction>(signOut),
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
