import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/data/sources/firebase_auth_datasoure.dart';
import 'package:music_app/domain/repository/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserCredential> signIn(String email, String password) =>
      datasource.signIn(email, password);

  @override
  Future<UserCredential> signInWithGoogle() => datasource.signInWithGoogle();

  @override
  Future<UserCredential> signInWithFacebook() =>
      datasource.signInWithFacebook();

  @override
  Future<UserCredential> register(String email, String password) =>
      datasource.register(email, password);

  @override
  Future<void> signOut() => datasource.signOut();

  @override
  Future<String?> getIdToken() => datasource.getIdToken() ?? Future.value(null);
}
