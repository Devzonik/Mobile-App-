import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';

import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.marginBottom = 12,
    this.isObSecure = false,
    this.maxLength,
    this.maxLines = 1,
    this.isEnabled = true,
    this.labelText,
    this.suffixIcon,
    this.validator,
    this.onTap,
    this.haveSuffix = false,
    this.onChanged,
    this.suffixIconSize,
    this.onSuffixTap,
    this.focusBorderColor,
    this.radius,
  }) : super(key: key);
  String? hintText, labelText, suffixIcon;
  double? marginBottom, suffixIconSize, radius;
  bool? isObSecure, isEnabled, haveSuffix;
  int? maxLength, maxLines;
  VoidCallback? onSuffixTap;
  Color? focusBorderColor;

  TextInputType? keyboardType;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;

  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              text: labelText!,
              size: 12,
              weight: FontWeight.w500,
              color: kDarkGreyColor,
              paddingBottom: 3,
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 24),
              boxShadow: [
                BoxShadow(
                  color: kGrey10Color.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 8,
                  offset: Offset(17, 3), // Shadow position
                ),
              ],
            ),
            child: TextFormField(
              cursorColor: kDarkGreyColor,
              onTap: onTap,
              enabled: isEnabled,
              validator: validator,
              maxLines: maxLines,
              maxLength: maxLength,
              onChanged: onChanged,
              obscureText: isObSecure!,
              obscuringCharacter: '*',
              controller: controller,
              textInputAction: TextInputAction.next,
              textAlignVertical:
                  suffixIcon != null ? TextAlignVertical.center : null,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 12,
                color: kDarkGreyColor,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.SPACE,
              ),
              decoration: InputDecoration(
                fillColor: kPrimaryColor,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: maxLines! > 1 ? 15 : 0,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: kHintColor,
                  fontFamily: AppFonts.SPACE,
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: haveSuffix! ? 40 : 16,
                ),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (haveSuffix!)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: onSuffixTap,
                          child: Image.asset(
                            suffixIcon!,
                            height: suffixIconSize ?? 20,
                          ),
                        ),
                      ),
                  ],
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: kInputBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(radius ?? 24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 24),
                  borderSide: BorderSide(
                    width: 1,
                    color: focusBorderColor ?? kSecondaryColor,
                  ),
                ),
                // Adjusting error text position
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kErrorColor, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kErrorColor, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                errorStyle: TextStyle(
                  fontFamily: AppFonts.MONTSERRAT,
                  fontSize: 10,
                  color: kErrorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
