import 'package:ara/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:ara/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ara/views/something_went_wrong.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Badgio());
}

class Badgio extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              title: 'Badgio',
              home: SomethingWentWrong(),
              theme: AriaTheme().theme,
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Badgio',
              home: SignInPage(),
              theme: AriaTheme().theme,
            );
          }

          // Should probably return something meaning it is loading
          return SomethingWentWrong();
        });
  }
}
