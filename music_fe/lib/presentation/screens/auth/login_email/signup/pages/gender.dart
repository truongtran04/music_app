import 'package:flutter/material.dart';

import '../../../../../../common/widgets/appbar/app_bar.dart';
import '../../../../../../common/widgets/background/bg_auth.dart';
import '../../../../../../common/widgets/text/text_title.dart';
import '../../../../../../core/navigations/app_router.dart';
import '../../../../../../core/configs/theme/app_colors.dart';

class Gender extends StatefulWidget {
  final String email;
  final String password;
  final DateTime dateOfBirth;
  const Gender({
    super.key,
    required this.email,
    required this.password,
    required this.dateOfBirth,
  });

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String? selectedGender;

  final List<String> genders = ["Nữ", "Nam", "Khác", "Không muốn nêu cụ thể"];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      // Có thể cập nhật lại widget.email, widget.password, widget.dateOfBirth nếu cần
    }
  }

  void _onGenderSelected(String gender) {
    if (widget.email.isNotEmpty &&
        widget.password.isNotEmpty &&
        widget.dateOfBirth != null &&
        gender.isNotEmpty) {
      AppRouter.router.navigateTo(
        context,
        '/termsOfService',
        routeSettings: RouteSettings(
          arguments: {
            'email': widget.email,
            'password': widget.password,
            'dateOfBirth': widget.dateOfBirth,
            'gender': gender,
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppbar(
        title: TextTitle(
          title: "Tạo tài khoản",
          fontSize: 18,
          letterSpacing: 0,
        ),
        onPressed: () {
          AppRouter.router.navigateTo(context, '/dateOfBirth');
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
                    title: "Giới tính của bạn là gì?",
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 5.0,
                      children: genders.map((gender) {
                        bool isSelected = gender == selectedGender;
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedGender = gender;
                              });
                              _onGenderSelected(gender);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.buttonStroke,
                                      width: 2)),
                            ),
                            child: Text(gender,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.buttonStroke,
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
