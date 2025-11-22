import 'package:fluro/fluro.dart';
import 'package:music_app/core/navigations/route_handlers.dart';

class AppRouter {
  static final FluroRouter router = FluroRouter();

  static void setupRouter() {
    router.define(
      '/',
      handler: splashHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/home',
      handler: homeHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/signInOrSignUp',
      handler: signInOrSignUpHandler,
      transitionType: TransitionType.none,
    );

    router.define(
      '/signin',
      handler: signInHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/signup',
      handler: signUpHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/registerEmail',
      handler: registerEmailHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/registerPassword',
      handler: registerPasswordHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/dateOfBirth',
      handler: dateOfBirthHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/gender',
      handler: genderHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/termsOfService',
      handler: termsOfServiceHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/login',
      handler: loginHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/loading',
      handler: loadingHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/rootApp',
      handler: rootAppHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/musicPlayer',
      handler: musicPlayerHandler,
      transitionType: TransitionType.inFromRight,
    );
  }

}
