import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

// ignore: must_be_immutable
class EditTextField extends StatelessWidget {
  EditTextField(
      {Key? key,
      this.controller,
      this.hint,
      this.label,
      this.onChanged,
      this.isObSecure = false,
      this.marginBottom = 15.0,
      this.maxLines,
      this.isFilled = true,
      this.filledColor,
      this.hintColor,
      this.haveLabel = true,
      this.labelSize,
      this.prefixIcon,
      this.suffixIcon})
      : super(key: key);
  String? label, hint;

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, haveLabel, isFilled;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Widget? suffixIcon;
  Widget? prefixIcon;
  Color? filledColor, hintColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            maxLines: maxLines ?? 1,
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.next,
            obscureText: isObSecure!,
            obscuringCharacter: '*',
            style: TextStyle(
              fontFamily: AppFonts.MONTSERRAT,
              fontSize: 14,
              color: kBlackColor2,
            ),
            decoration: InputDecoration(
              label: MyText(
                text: label ?? '',
                size: 10,
                color: kBlackColor,
              ),
              prefixIcon: prefixIcon,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              // filled: isFilled,
              // fillColor: filledColor ?? kTertiaryColor,
              hintText: hint,
              suffixIcon: suffixIcon,
              hintStyle: TextStyle(
                fontFamily: AppFonts.MONTSERRAT,
                fontSize: 12,
                color: kGrey5Color,
              ),
              filled: true,
              fillColor: kGrey1Color,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
