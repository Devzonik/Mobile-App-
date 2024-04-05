import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  CustomCheckBox({
    Key? key,
    required this.isActive,
    required this.onTap,
    this.unSelectedColor,
  }) : super(key: key);

  final bool isActive;
  final VoidCallback onTap;
  Color? unSelectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 230,
        ),
        curve: Curves.easeInOut,
        height: 19,
        width: 19,
        decoration: BoxDecoration(
          color: isActive ? kTertiaryColor : Colors.transparent,
          border: Border.all(
            width: 1.0,
            color: unSelectedColor ?? kTertiaryColor,
          ),
          borderRadius: BorderRadius.circular(3.3),
        ),
        child: !isActive
            ? SizedBox()
            : Icon(
                Icons.check,
                size: 11,
                color: kQuaternaryColor,
              ),
      ),
    );
  }
}
