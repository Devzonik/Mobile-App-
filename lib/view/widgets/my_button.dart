import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton(
      {required this.buttonText,
      required this.onTap,
      this.fillColor,
      this.borderColor,
      this.height = 48,
      this.btntextsize,
      this.btnColor = kSecondaryColor,
      this.isactive = true,
      this.choiceIcon,
      this.hasicon,
      this.btnTextColor});

  final String buttonText;
  final VoidCallback onTap;
  double? height;
  bool? isactive;
  Color? fillColor;
  Color? btnColor;
  Color? borderColor;
  bool? hasicon;
  Widget? choiceIcon;
  double? btntextsize;
  Color? btnTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 36,
      decoration: BoxDecoration(
          color: fillColor ?? kSecondaryColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            isactive == false
                ? BoxShadow()
                : BoxShadow(
                    color: kBlack2Color.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(5, 3), // Shadow position
                  ),
          ],
          border: isactive == false
              ? Border.all(color: borderColor ?? kQuaternaryColor)
              : null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kTertiaryColor.withOpacity(0.1),
          highlightColor: kTertiaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hasicon == true
                    ? choiceIcon ?? const SizedBox.shrink()
                    : const SizedBox.shrink(),
                MyText(
                  text: buttonText,
                  size: btntextsize ?? 14,
                  weight: FontWeight.bold,
                  color: isactive == false
                      ? btnTextColor ?? kPrimaryColor
                      : kPrimaryColor,
                  fontFamily: AppFonts.SPACE,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
