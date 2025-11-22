import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:music_app/common/widgets/text/text_title.dart';
import 'package:music_app/common/widgets/text_field/auth_text_field.dart';
import '../../../../../../common/widgets/appbar/app_bar.dart';
import '../../../../../../common/widgets/background/bg_auth.dart';
import '../../../../../../common/widgets/button/button_primary.dart';
import '../../../../../../core/navigations/app_router.dart';
import '../../../../../../core/configs/theme/app_colors.dart';

class RegisterEmail extends StatefulWidget {
  const RegisterEmail({super.key});

  @override
  State<RegisterEmail> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterEmail> {
  FocusNode _focusNode = FocusNode();
  Color _backgroundColor = AppColors.garyBCK2;
  TextEditingController _emailController = TextEditingController();
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
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      String email = _emailController.text;
      if (email.isEmpty) {
        _isButtonEnabled = false;
      } else if (!EmailValidator.validate(email)) {
        _isButtonEnabled = false;
      } else {
        _isButtonEnabled = true;
      }
    });
  }

  void _continue() {
    if (_isButtonEnabled) {
      AppRouter.router.navigateTo(
        context,
        '/registerPassword',
        routeSettings: RouteSettings(arguments: _emailController.text.trim()),
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
          AppRouter.router.navigateTo(context, '/signup');
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
                    title: "Email của bạn là gì?",
                    height: 10,
                  ),
                  AuthTextField(
                      controller: _emailController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.emailAddress,
                      fillColor: _backgroundColor),
                  TextTitle(
                    title: "Bạn cần xác nhận email này sau.",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
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
