import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:ara/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ara/theme.dart';
import 'package:ara/routes.dart';
import 'package:ara/redux/app_reducer.dart';
import 'package:ara/redux/authentication/auth_middleware.dart';
import 'package:ara/views/sign_in.dart';
import 'package:ara/views/home.dart';

class BadgioApp extends StatefulWidget {
  const BadgioApp({
    Key key,
  }) : super(key: key);

  @override
  _BadgioAppState createState() => _BadgioAppState();
}

class _BadgioAppState extends State<BadgioApp> {
  Store<AppState> store;
  static final _navigatorKey = GlobalKey<NavigatorState>();
  final userRepository = UserRepository(FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();
    store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: createAuthMiddleware(userRepository, _navigatorKey),
    );
    store.dispatch(VerifyAuthenticationStateAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Badgio',
          theme: AriaTheme().theme,
          home: SignInPage(),
          routes: {
            Routes.signIn: (context) {
              return SignInPage();
            },
            Routes.home: (context) {
              return HomePage();
            }
          },
          navigatorKey: _navigatorKey,
        ));
  }
}
