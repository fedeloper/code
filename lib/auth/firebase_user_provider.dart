// @dart = 2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class MagicMirrorFirebaseUser {
  MagicMirrorFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

MagicMirrorFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<MagicMirrorFirebaseUser> magicMirrorFirebaseUserStream() => FirebaseAuth
    .instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<MagicMirrorFirebaseUser>(
        (user) => currentUser = MagicMirrorFirebaseUser(user));
