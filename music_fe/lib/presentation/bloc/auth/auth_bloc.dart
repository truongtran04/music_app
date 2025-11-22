import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/repository/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLoginWithGoogleRequested>(_onLoginWithGoogleRequested);
    on<AuthLoginWithFacebookRequested>(_onLoginWithFacebookRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthGetTokenRequested>(_onGetTokenRequested);
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential =
          await authRepository.signIn(event.email, event.password);
      final token = await credential.user?.getIdToken();
      emit(AuthSuccess(user: credential.user, token: token));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLoginWithGoogleRequested(
      AuthLoginWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signInWithGoogle();
      final token = await credential.user?.getIdToken();
      emit(AuthSuccess(user: credential.user, token: token));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLoginWithFacebookRequested(
      AuthLoginWithFacebookRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signInWithFacebook();
      final token = await credential.user?.getIdToken();
      emit(AuthSuccess(user: credential.user, token: token));
    } catch (e) {
      print('Facebook login error: $e');
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential =
          await authRepository.register(event.email, event.password);
      final token = await credential.user?.getIdToken();
      emit(AuthSuccess(user: credential.user, token: token));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onGetTokenRequested(
      AuthGetTokenRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await authRepository.getIdToken();
      emit(AuthSuccess(user: FirebaseAuth.instance.currentUser, token: token));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
