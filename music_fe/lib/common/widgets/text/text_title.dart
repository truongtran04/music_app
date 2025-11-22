import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String title;
  final bool ? softWrap;
  final double ? letterSpacing;
  final double ? fontSize;
  final FontWeight ? fontWeight;
  final Color ? color;
  final TextAlign ? textAlign;
  final double ? height;
  final double ? left;

  const TextTitle({
    required this.title,
    this.softWrap,
    this.letterSpacing,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.textAlign,
    this.height,
    this.left,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left ?? 0,
      ),
      child: Column(
        children: [
          Text(
            title,
            softWrap: softWrap,
            style: TextStyle(
              fontWeight: fontWeight ?? FontWeight.bold,
              fontSize: fontSize ?? 25,
              color: color ?? Colors.white,
              letterSpacing: letterSpacing ?? 0,
            ),
            textAlign: textAlign ?? TextAlign.center,
          ),
          SizedBox(height: height ?? 0,)
        ],
      ),
    );
  }
}
