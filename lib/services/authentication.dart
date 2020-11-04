import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User> get authStateChanges => auth.authStateChanges();

  Future<User> signIn(String email, String password) async {
    try {
      User user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      return user;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }
}
