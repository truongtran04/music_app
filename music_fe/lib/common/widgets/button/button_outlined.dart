import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';

import '../../../core/configs/theme/app_colors.dart';

class ButtonOutlined extends StatelessWidget {
  final String? image;
  final String title;
  final VoidCallback onPressed;
  final double ? width;
  final double ? height;

  const ButtonOutlined({
    this.image,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.buttonStroke, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            fixedSize: Size( width ?? double.infinity, height ?? 50),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (image != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: SvgPicture.asset(image!, width: 25),
                  ),
                ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
