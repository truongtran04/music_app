part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;
  final String? token;
  AuthSuccess({required this.user, this.token});
  @override
  List<Object?> get props => [user, token];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
