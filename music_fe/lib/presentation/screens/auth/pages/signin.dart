import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/common/widgets/background/bg_auth.dart';
import 'package:music_app/common/widgets/button/button_outlined.dart';
import 'package:music_app/common/widgets/logo/logo.dart';
import 'package:music_app/common/widgets/text/text_title.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../common/widgets/button/button_primary.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/navigations/app_router.dart';
import '../../../../data/sources/firebase_auth_datasoure.dart';
import '../../../../domain/repository/auth/auth_repository_impl.dart';
import '../../../../presentation/bloc/auth/auth_bloc.dart';
import '../login_email/signin/pages/login.dart';

class SignInPage extends StatelessWidget {
  final VoidCallback onSignUpPressed;
  const SignInPage({
    required this.onSignUpPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepositoryImpl(FirebaseAuthDatasource())),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Show loading if needed
          } else if (state is AuthSuccess) {
            AppRouter.router.navigateTo(context, '/rootApp', replace: true);
          } else if (state is AuthFailure) {
            // Hiển thị lỗi cho tất cả trường hợp, bao gồm cả đăng nhập Google/Facebook
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: BackgroundAuth(
            child: Column(
              children: [
                const Spacer(),
                Logo(),
                TextTitle(title: "Đăng nhập vào Spotify"),
                const Spacer(),
                Builder(
                  builder: (context) => _buildButtons(context),
                ),
              ],
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
                    child: LoginPage(),
                  ),
                ),
              );
            },
          ),
          ButtonOutlined(
            image: AppVectors.logoGG,
            title: 'Tiếp tục với Google',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLoginWithGoogleRequested());
            },
          ),
          ButtonOutlined(
            image: AppVectors.logoFB,
            title: 'Tiếp tục với Facebook',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLoginWithFacebookRequested());
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
          'Bạn chưa có tài khoản?',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: onSignUpPressed,
          child: Text(
            'Đăng ký',
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
