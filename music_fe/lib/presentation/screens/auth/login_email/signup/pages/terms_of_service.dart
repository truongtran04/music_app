import 'package:flutter/material.dart';
import 'package:music_app/common/widgets/text_field/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../../common/widgets/appbar/app_bar.dart';
import '../../../../../../common/widgets/background/bg_auth.dart';
import '../../../../../../common/widgets/button/button_primary.dart';
import '../../../../../../common/widgets/text/text_title.dart';
import '../../../../../../core/navigations/app_router.dart';
import '../../../../../../core/configs/theme/app_colors.dart';

class TermsOfService extends StatefulWidget {
  final String email;
  final String password;
  final DateTime dateOfBirth;
  final String gender;
  const TermsOfService({
    super.key,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
  });

  @override
  State<TermsOfService> createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  FocusNode _focusNode = FocusNode();
  Color _backgroundColor = AppColors.garyBCK2;
  TextEditingController _fullNameController = TextEditingController();
  bool? _isCheck1 = false;
  bool? _isCheck2 = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _backgroundColor =
            _focusNode.hasFocus ? AppColors.buttonStroke : AppColors.garyBCK2;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    // Không cần cập nhật lại widget, vì đã truyền đúng từ handler
  }

  Future<void> _onRegister() async {
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên!')),
      );
      return;
    }
    if (widget.email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email!')),
      );
      return;
    }
    if (widget.password.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mật khẩu!')),
      );
      return;
    }
    if (_isCheck1 != true || _isCheck2 != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đồng ý với các điều khoản!')),
      );
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email.trim(),
        password: widget.password.trim(),
      );
      await userCredential.user
          ?.updateDisplayName(_fullNameController.text.trim());

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/rootApp');
      }
    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? 'Đăng ký thất bại';
      if (e.code == 'email-already-in-use') {
        msg = 'Email đã được sử dụng!';
      } else if (e.code == 'invalid-email') {
        msg = 'Email không hợp lệ!';
      } else if (e.code == 'weak-password') {
        msg = 'Mật khẩu quá yếu!';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: BasicAppbar(
        title: TextTitle(
          title: "Tạo tài khoản",
          fontSize: 18,
          letterSpacing: 0,
        ),
        onPressed: () {
          AppRouter.router.navigateTo(context, '/gender');
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
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitle(
                          title: "Tên của bạn là gì?",
                          height: 10,
                        ),
                        AuthTextField(
                          controller: _fullNameController,
                          focusNode: _focusNode,
                          fillColor: _backgroundColor,
                        ),
                        TextTitle(
                          title:
                              "Thông tin này sẽ xuất hiện trên hồ sơ của bạn.",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 10,
                        ),
                      ]),
                  Divider(
                    thickness: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      TextTitle(
                        title:
                            'Bằng việc nhấn vào "Tạo tài khoản", bạn đồng ý với Điều khoản sử dụng của Spotify.',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        textAlign: TextAlign.left,
                        height: 15,
                      ),
                      TextTitle(
                        title: 'Điều khoản sử dụng',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.primary,
                        height: 15,
                      ),
                      TextTitle(
                        title:
                            'Để tìm hiểu thêm về cách thức Spotify thu thập, sử dụng, chia sẻ, và bảo vệ dữ liệu cá nhân của bạn, vui lòng xem Chính sách quyền riêng tư của Spotify.',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        textAlign: TextAlign.left,
                        height: 15,
                      ),
                      TextTitle(
                        title: 'Chính sách quyền riêng tư',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.primary,
                        height: 15,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextTitle(
                            title:
                                'Tôi không muốn nhận tin nhắn tiếp thị từ spotify',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            textAlign: TextAlign.left,
                          ),
                          Transform.scale(
                            scale: 1.25,
                            child: Checkbox(
                              value: _isCheck1,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onChanged: (newBool) {
                                setState(() {
                                  _isCheck1 = newBool;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextTitle(
                              title:
                                  'Chia sẽ dữ liệu đăng ký của tôi với các nhà cung cấp nội dung Spotify nhằm mục đích tiếp thị',
                              softWrap: true,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Transform.scale(
                            scale: 1.25,
                            child: Checkbox(
                              value: _isCheck2,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onChanged: (newBool) {
                                setState(() {
                                  _isCheck2 = newBool;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ButtonPrimary(
                      title: 'Tạo tài khoản',
                      onPressed: _onRegister,
                      width: 150,
                      height: 40,
                      color: AppColors.lightBackground,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
