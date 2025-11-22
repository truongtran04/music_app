import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashNavigateToHome extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}
