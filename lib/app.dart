import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/authentication/auth_actions.dart';
import 'package:ara/redux/collections/collections_middleware.dart';
import 'package:ara/redux/redeem/redeem_middleware.dart';
import 'package:ara/repositories/collection_repository.dart';
import 'package:ara/repositories/user_repository.dart';
import 'package:ara/views/main_screen.dart';
import 'package:ara/views/redeem.dart';
import 'package:ara/views/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ara/theme.dart';
import 'package:ara/routes.dart';
import 'package:ara/redux/app_reducer.dart';
import 'package:ara/redux/authentication/auth_middleware.dart';
import 'package:ara/views/sign_in.dart';

class BadgioApp extends StatefulWidget {
  const BadgioApp({
    Key key,
  }) : super(key: key);

  @override
  _BadgioAppState createState() => _BadgioAppState();
}

class _BadgioAppState extends State<BadgioApp> {
  Store<AppState> store;
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    Routes.signIn: GlobalKey<NavigatorState>(),
    Routes.home: GlobalKey<NavigatorState>(),
    Routes.search: GlobalKey<NavigatorState>(),
    Routes.collections: GlobalKey<NavigatorState>(),
    Routes.you: GlobalKey<NavigatorState>(),
    Routes.redeem: GlobalKey<NavigatorState>(),
  };
  final userRepository = UserRepository(FirebaseAuth.instance);
  final collectionRepository = CollectionRepository();

  @override
  void initState() {
    super.initState();
    store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: createAuthMiddleware(
        userRepository,
        _navigatorKeys[Routes.signIn],
      )
        ..addAll(
          createCollectionsMiddleware(
            collectionRepository,
            _navigatorKeys,
          ),
        )
        ..addAll(
          createImportDataMiddleware(
            collectionRepository,
            _navigatorKeys,
          ),
        )
        ..addAll(
          createBadgesMiddleware(
            collectionRepository,
            _navigatorKeys,
          ),
        )
        ..addAll(
          createRedeemMiddleware(
            collectionRepository,
            _navigatorKeys,
          ),
        ),
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
        navigatorKey: _navigatorKeys[Routes.signIn],
        routes: {
          Routes.signIn: (context) {
            return SignInPage();
          },
          Routes.signUp: (context) {
            return SignUpPage();
          },
          Routes.home: (context) {
            return MainScreen(navigatorKeys: _navigatorKeys);
          },
          Routes.redeem: (context) {
            return RedeemPage();
          },
        },
      ),
    );
  }
}
