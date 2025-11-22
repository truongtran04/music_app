import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:music_app/common/widgets/button/button_outlined.dart';
import 'package:music_app/common/widgets/button/button_primary.dart';
import 'package:music_app/common/widgets/text/text_title.dart';

import '../../../../common/widgets/background/bg_auth.dart';
import '../../../../common/widgets/logo/logo.dart';
import '../../../../core/navigations/app_router.dart';

class SignInOrSignUpPage extends StatelessWidget {
  const SignInOrSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAuth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            Logo(),
            TextTitle(title: "Hàng triệu bài hát.") ,
            TextTitle(title: "Miễn phí trên Spotify."),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 60),
              child: Column(
                children: [
                  ButtonPrimary(
                    title: 'Đăng ký miễn phí',
                    onPressed: () {
                      AppRouter.router.navigateTo(context, '/signup', transition: TransitionType.inFromRight);
                    },
                  ),
                  ButtonOutlined(
                    title: 'Đăng nhập',
                    onPressed: () {
                      AppRouter.router.navigateTo(context, '/signin', transition: TransitionType.inFromRight);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
