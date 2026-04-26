import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential?> signInAnonymously() async {
    if (_auth.currentUser != null) return null;
    return _auth.signInAnonymously();
  }
}
