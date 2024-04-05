import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';

import 'my_text_widget.dart';

class AuthHeading extends StatelessWidget {
  const AuthHeading({
    super.key,
    required this.heading,
    this.paddingTop,
    this.paddingBottom,
    this.size,
    this.textAlign,
  });

  final String heading;
  final double? paddingTop;
  final double? paddingBottom;
  final double? size;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return MyText(
      paddingTop: paddingTop ?? 10,
      text: heading,
      size: size ?? 24,
      color: kTertiaryColor,
      weight: FontWeight.w600,
      lineHeight: 1.5,
      paddingBottom: paddingBottom ?? 10,
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
