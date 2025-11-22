import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  // Sign in with Firebase
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithFacebook();

  Future<UserCredential> register(String email, String password);
  Future<void> signOut();
  Future<String?> getIdToken();
}
