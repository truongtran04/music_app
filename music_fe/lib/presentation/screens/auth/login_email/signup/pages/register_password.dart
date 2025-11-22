import 'package:flutter/material.dart';
import 'package:music_app/common/widgets/appbar/app_bar.dart';
import 'package:music_app/common/widgets/background/bg_auth.dart';
import 'package:music_app/common/widgets/button/button_primary.dart';
import 'package:music_app/common/widgets/text_field/auth_text_field.dart';
import 'package:music_app/core/navigations/app_router.dart';
import 'package:music_app/core/configs/theme/app_colors.dart';

import '../../../../../../common/widgets/text/text_title.dart';

class RegisterPassword extends StatefulWidget {
  final String email;
  const RegisterPassword({super.key, required this.email});

  @override
  State<RegisterPassword> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPassword> {
  FocusNode _focusNode = FocusNode();
  Color _backgroundColor = AppColors.garyBCK2;
  bool _isObscure = true;
  TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _backgroundColor =
            _focusNode.hasFocus ? AppColors.buttonStroke : AppColors.garyBCK2;
      });
    });
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    String password = _passwordController.text;
    setState(() {
      if (password.length < 8 ||
          !RegExp(r'(?=.*[A-Z])').hasMatch(password) ||
          !RegExp(r'(?=.*[a-z])').hasMatch(password) ||
          !RegExp(r'(?=.*\d)').hasMatch(password) ||
          !RegExp(r'(?=.*[@\$!%*?&])').hasMatch(password)) {
        _isButtonEnabled = false;
      } else {
        _isButtonEnabled = true;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty && widget.email != args) {
      // Không cần cập nhật widget.email, chỉ cần dùng widget.email khi truyền tiếp
    }
  }

  void _continue() {
    if (_isButtonEnabled && widget.email.isNotEmpty) {
      AppRouter.router.navigateTo(
        context,
        '/dateOfBirth',
        routeSettings: RouteSettings(
          arguments: {
            'email': widget.email,
            'password': _passwordController.text.trim(),
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppbar(
        title: TextTitle(
          title: "Tạo tài khoản",
          fontSize: 18,
          letterSpacing: 0,
        ),
        onPressed: () {
          AppRouter.router.navigateTo(context, '/registerEmail');
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
                    title: "Tạo một mật khẩu",
                    height: 10,
                  ),
                  AuthTextField(
                    controller: _passwordController,
                    focusNode: _focusNode,
                    obscureText: _isObscure,
                    fillColor: _backgroundColor,
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  TextTitle(
                    title:
                        "Sử dụng ít nhất 8 kí tự, bao gồm kí tự in hoa, in thường, kí tự số và kí tự đặc biệt.",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ButtonPrimary(
                  title: 'Tiếp',
                  onPressed: _isButtonEnabled ? () => _continue() : () {},
                  width: 100,
                  height: 40,
                  color: _isButtonEnabled
                      ? AppColors.lightBackground
                      : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
