import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode ? focusNode;
  final bool ? obscureText;
  final bool ? readOnly;
  final TextInputType ? keyboardType;
  final Color ? cursorColor;
  final Color ? fillColor;
  final Widget ? suffixIcon;
  final Widget ? prefixIcon;
  final double ? height;
  final Future<void> Function() ? onTap;

  const AuthTextField({
    required this.controller,
    this.focusNode,
    this.obscureText,
    this.readOnly,
    this.keyboardType,
    this.cursorColor,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.height,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText ?? false,
          readOnly: readOnly ?? false,
          keyboardType: keyboardType ?? TextInputType.text,
          cursorColor: cursorColor ?? Colors.white,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? AppColors.garyBCK2,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: onTap,
        ),
        SizedBox(height: height ?? 5,)
      ],
    );
  }
}
