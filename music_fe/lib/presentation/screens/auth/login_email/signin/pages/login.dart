import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/common/widgets/background/bg_auth.dart';
import '../../../../../../common/widgets/appbar/app_bar.dart';
import '../../../../../../common/widgets/button/button_primary.dart';
import '../../../../../../common/widgets/text/text_title.dart';
import '../../../../../../common/widgets/text_field/auth_text_field.dart';
import '../../../../../../core/configs/theme/app_colors.dart';
import '../../../../../../core/navigations/app_router.dart';
import '../../../../../../presentation/bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  Color _emailBackgroundColor = AppColors.garyBCK2;
  Color _passwordBackgroundColor = AppColors.garyBCK2;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _focusNodeEmail.addListener(() {
      setState(() {
        _emailBackgroundColor = _focusNodeEmail.hasFocus
            ? AppColors.buttonStroke
            : AppColors.garyBCK2;
      });
    });

    _focusNodePassword.addListener(() {
      setState(() {
        _passwordBackgroundColor = _focusNodePassword.hasFocus
            ? AppColors.buttonStroke
            : AppColors.garyBCK2;
      });
    });

    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled =
          EmailValidator.validate(_emailController.text.trim()) &&
              _passwordController.text.trim().isNotEmpty;
    });
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context
        .read<AuthBloc>()
        .add(AuthLoginRequested(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    // Lấy AuthBloc từ cha bằng BlocProvider.value khi push sang LoginPage!
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // Hiển thị loading nếu muốn
        } else if (state is AuthSuccess) {
          AppRouter.router.navigateTo(context, '/rootApp', replace: true);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: BasicAppbar(
          title: TextTitle(
            title: "Đăng nhập",
            fontSize: 18,
            letterSpacing: 0,
          ),
          onPressed: () {
            AppRouter.router.navigateTo(context, '/signin');
          },
        ),
        body: BackgroundAuth(
          child: Padding(
            padding: const EdgeInsets.only(
                top: kToolbarHeight + 80, left: 20, right: 20),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle(
                      title: "Email hoặc tên người dùng",
                    ),
                    AuthTextField(
                        controller: _emailController,
                        focusNode: _focusNodeEmail,
                        keyboardType: TextInputType.emailAddress,
                        fillColor: _emailBackgroundColor),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle(
                      title: "Mật khẩu",
                    ),
                    AuthTextField(
                      controller: _passwordController,
                      focusNode: _focusNodePassword,
                      obscureText: _isObscure,
                      keyboardType: TextInputType.visiblePassword,
                      fillColor: _passwordBackgroundColor,
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ButtonPrimary(
                    title: 'Đăng nhập',
                    onPressed: _isButtonEnabled ? () => _login() : () {},
                    width: 140,
                    height: 40,
                    color: _isButtonEnabled
                        ? AppColors.lightBackground
                        : Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      minimumSize: const Size(0, 30),
                    ),
                    child: Text(
                      "Đăng nhập không cần mật khẩu",
                      style: TextStyle(
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
