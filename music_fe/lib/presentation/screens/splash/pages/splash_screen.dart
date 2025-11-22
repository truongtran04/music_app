import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/navigations/app_router.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  void _navigateAfterDelay(BuildContext context, String route) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return; // Kiểm tra nếu context còn hợp lệ
    AppRouter.router.navigateTo(context, route);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          _navigateAfterDelay(context, '/signInOrSignUp');
        } else if (state is SplashNavigateToOnboarding) {
          _navigateAfterDelay(context, '/signInOrSignUp');
        }
      },
      child: Scaffold(
        body: Center(
          child: SvgPicture.asset(
            AppVectors.greenLogo,
            height: size.height * 0.15,
            width: size.width * 0.15,
          ),
        ),
      ),
    );
  }
}
