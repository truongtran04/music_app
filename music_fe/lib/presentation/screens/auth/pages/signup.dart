import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/presentation/screens/auth/login_email/signup/pages/register_email.dart';

import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../common/widgets/background/bg_auth.dart';
import '../../../../common/widgets/button/button_outlined.dart';
import '../../../../common/widgets/button/button_primary.dart';
import '../../../../common/widgets/logo/logo.dart';
import '../../../../common/widgets/text/text_title.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/navigations/app_router.dart';
import '../../../../data/sources/firebase_auth_datasoure.dart';
import '../../../../domain/repository/auth/auth_repository_impl.dart';
import '../../../../presentation/bloc/auth/auth_bloc.dart';

class SignUpPage extends StatelessWidget {
  final VoidCallback onSignInPressed;
  const SignUpPage({required this.onSignInPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepositoryImpl(FirebaseAuthDatasource())),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/rootApp');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
            extendBodyBehindAppBar: true,
            body: BackgroundAuth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Logo(),
                  TextTitle(title: "Đăng ký để bắt đầu nghe"),
                  const Spacer(),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 60),
      child: Column(
        children: [
          ButtonPrimary(
            icon: Icons.email_outlined,
            title: 'Tiếp tục với email',
            onPressed: () {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: authBloc,
                    child: RegisterEmail(),
                  ),
                ),
              );
            },
          ),
          ButtonOutlined(
            image: AppVectors.logoGG,
            title: 'Tiếp tục với Google',
            onPressed: () {
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthLoginWithGoogleRequested());
            },
          ),
          ButtonOutlined(
            image: AppVectors.logoFB,
            title: 'Tiếp tục với Facebook',
            onPressed: () {
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthLoginWithFacebookRequested());
            },
          ),
          const SizedBox(height: 10),
          _buildSignUpSection(context),
        ],
      ),
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Bạn đã có tài khoản?',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: onSignInPressed,
          child: Text(
            'Đăng nhập',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
