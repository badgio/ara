import 'package:ara/models/info_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ara/models/mobile_user.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  InfoUser _user;

  UserRepository(this._firebaseAuth);

  Future<MobileUser> signIn(String email, String password) async {
    final firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return await _fromFirebaseUser(firebaseUser.user);
  }

  Stream<MobileUser> getAuthenticationStateChange() {
    return _firebaseAuth
        .authStateChanges()
        .asyncMap((firebaseUser) => _fromFirebaseUser(firebaseUser));
  }

  Future<MobileUser> _fromFirebaseUser(User firebaseUser) async {
    if (firebaseUser == null) return Future.value(null);
    // get rest of user details from own api TODO
    MobileUser user =
        MobileUser(email: firebaseUser.email, id: firebaseUser.uid);
    return user;
  }

  Future<InfoUser> getProfile() async {
    return await Future(() => _user);
  }

  void addInfoUser(InfoUser user) {
    _user = user;
  }
}