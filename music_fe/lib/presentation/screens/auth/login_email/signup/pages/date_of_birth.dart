import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/common/widgets/text_field/auth_text_field.dart';
import '../../../../../../common/widgets/appbar/app_bar.dart';
import '../../../../../../common/widgets/background/bg_auth.dart';
import '../../../../../../common/widgets/button/button_primary.dart';
import '../../../../../../common/widgets/text/text_title.dart';
import '../../../../../../core/navigations/app_router.dart';
import '../../../../../../core/configs/theme/app_colors.dart';

class DateOfBirth extends StatefulWidget {
  final String email;
  final String password;
  const DateOfBirth({super.key, required this.email, required this.password});

  @override
  State<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  FocusNode _focusNode = FocusNode();
  Color _backgroundColor = AppColors.garyBCK2;
  bool _isButtonEnabled = true;
  String? _errorText;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus(); // Bỏ focus trước khi mở DatePicker
        _selectDate();
      }
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        _validateAge();
      });

      // Ẩn bàn phím và bỏ focus khỏi TextField
      _focusNode.unfocus();
    }
  }

  void _validateAge() {
    if (_selectedDate == null) return;

    final now = DateTime.now();
    final age = now.year -
        _selectedDate!.year -
        (now.month < _selectedDate!.month ||
                (now.month == _selectedDate!.month &&
                    now.day < _selectedDate!.day)
            ? 1
            : 0);

    if (age >= 18) {
      setState(() {
        _errorText = null;
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _errorText = 'Bạn phải ít nhất 18 tuổi.';
        _isButtonEnabled = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      if (args['email'] != null && args['password'] != null) {
        // Nếu cần cập nhật lại widget.email, widget.password, hãy truyền đúng từ đầu
      }
    }
  }

  void _validateAndContinue() {
    if (_isButtonEnabled &&
        widget.email.isNotEmpty &&
        widget.password.isNotEmpty &&
        _selectedDate != null) {
      AppRouter.router.navigateTo(
        context,
        '/gender',
        routeSettings: RouteSettings(
          arguments: {
            'email': widget.email,
            'password': widget.password,
            'dateOfBirth': _selectedDate,
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
          AppRouter.router.navigateTo(context, '/registerPassword');
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextTitle(
                    title: "Ngày sinh của bạn là gì?",
                    height: 10,
                  ),
                  AuthTextField(
                    controller: _dateController,
                    focusNode: _focusNode,
                    readOnly: true,
                    fillColor: _backgroundColor,
                    prefixIcon: Icon(Icons.calendar_month_rounded),
                    onTap: _selectDate,
                  ),
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorText!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ButtonPrimary(
                  title: 'Tiếp',
                  onPressed:
                      _isButtonEnabled ? () => _validateAndContinue() : () {},
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
