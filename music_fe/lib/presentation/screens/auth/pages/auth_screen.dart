import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:music_app/common/widgets/appbar/app_bar.dart';
import 'package:music_app/common/widgets/background/bg_auth.dart';
import 'package:music_app/presentation/screens/auth/pages/signin.dart';
import 'package:music_app/presentation/screens/auth/pages/signup.dart';

import '../../../../core/navigations/app_router.dart';

class AuthPage extends StatefulWidget {
  final bool isSignIn;

  const AuthPage({
    required this.isSignIn,
    super.key
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin  {

  late bool _isSignIn;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _isSignIn = widget.isSignIn;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(_controller);

    _controller.forward();
  }

  void _togglePage() {
    setState(() {
      _isSignIn = !_isSignIn;
      _controller.forward(from: 0);
    });

    // Cập nhật URL mà không cần load lại trang
    AppRouter.router.navigateTo(
      context,
      _isSignIn ? '/signin' : '/signup',
      transition: TransitionType.none,
      replace: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppbar(),
      body: Stack(
        children: [
          if (!_isSignIn)
            BackgroundAuth(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SignUpPage(onSignInPressed: _togglePage),
                ),
              ),
            ),
          if (_isSignIn)
            BackgroundAuth(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SignInPage(onSignUpPressed: _togglePage),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
