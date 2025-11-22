import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';

import '../../../core/configs/theme/app_colors.dart';

class ButtonPrimary extends StatelessWidget {
  final IconData ? icon;
  final String title;
  final VoidCallback onPressed;
  final double ? width;
  final double ? height;
  final Color ? color;

  const ButtonPrimary({
    this.icon,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 0,
            fixedSize: Size( width ?? double.infinity, height ?? 50),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon bên trái
              if (icon != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    icon,
                    size: 30,
                    color: context.isDarkMode ? Colors.white : Colors.black
                  ),
                ),
              // Text ở chính giữa
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.black : Colors.white,
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
