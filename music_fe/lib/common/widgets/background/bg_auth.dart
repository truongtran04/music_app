import 'package:flutter/material.dart';
import 'package:music_app/core/configs/theme/app_colors.dart';

class BackgroundAuth extends StatelessWidget {
  final Widget child;

  const BackgroundAuth({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _buildGradientBackground(),
      child: child,
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.white.withOpacity(0.19),
          AppColors.black.withOpacity(0.09),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}
