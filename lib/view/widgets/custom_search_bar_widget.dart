// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.5),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          fontSize: 14,
          color: kGreyColor3,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          filled: true,
          fillColor: kBlackColor,
          hintText: "Search something",
          hintStyle: TextStyle(
            fontSize: 14,
            color: kQuaternaryColor,
          ),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //   Image.asset(
              // //    Assets.imagesSearchIcon,
              //     height: 18,
              //     color: kSecondaryColor,
              //   ),
            ],
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
