import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:music_app/presentation/screens/auth/login_email/signin/pages/login.dart';
import 'package:music_app/presentation/screens/auth/login_email/signup/pages/date_of_birth.dart';
import 'package:music_app/presentation/screens/auth/login_email/signup/pages/gender.dart';
import 'package:music_app/presentation/screens/auth/login_email/signup/pages/register_email.dart';
import 'package:music_app/presentation/screens/auth/login_email/signup/pages/register_password.dart';
import 'package:music_app/presentation/screens/auth/login_email/signup/pages/terms_of_service.dart';
import 'package:music_app/presentation/screens/auth/pages/auth_screen.dart';

import 'package:music_app/presentation/screens/auth/pages/signin_or_signup_screen.dart';

import 'package:music_app/presentation/screens/loading/pages/loading.dart';
import 'package:music_app/presentation/screens/music_player/music_player_screen.dart';
import 'package:music_app/root_app.dart';

import '../../presentation/screens/home/pages/home_screen.dart';
import '../../presentation/screens/splash/pages/splash_screen.dart';

var splashHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const SplashPage();
  },
);

var homeHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    // Trả về RootApp thay vì HomePage
    return const RootApp();
  },
);

var signInOrSignUpHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const SignInOrSignUpPage();
  },
);

var signInHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const AuthPage(isSignIn: true);
  },
);

var signUpHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const AuthPage(isSignIn: false);
  },
);

var registerEmailHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const RegisterEmail();
  },
);

var registerPasswordHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    final args = ModalRoute.of(context!)?.settings.arguments;
    return RegisterPassword(
      email: args is String ? args : '',
    );
  },
);

Handler dateOfBirthHandler = Handler(
  handlerFunc: (context, parameters) {
    final args = ModalRoute.of(context!)?.settings.arguments as Map?;
    return DateOfBirth(
      email: args?['email'] ?? '',
      password: args?['password'] ?? '',
    );
  },
);

Handler genderHandler = Handler(
  handlerFunc: (context, parameters) {
    final args = ModalRoute.of(context!)?.settings.arguments as Map?;
    return Gender(
      email: args?['email'] ?? '',
      password: args?['password'] ?? '',
      dateOfBirth: args?['dateOfBirth'],
    );
  },
);

Handler termsOfServiceHandler = Handler(
  handlerFunc: (context, parameters) {
    final args = ModalRoute.of(context!)?.settings.arguments as Map?;
    return TermsOfService(
      email: args?['email'] ?? '',
      password: args?['password'] ?? '',
      dateOfBirth: args?['dateOfBirth'],
      gender: args?['gender'] ?? '',
    );
  },
);

var loginHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const LoginPage();
  },
);

var loadingHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const LoadingPage();
  },
);

var rootAppHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const RootApp();
  },
);

var musicPlayerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const MusicPlayerPage();
  },
);
