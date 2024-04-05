import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';

BoxDecoration circle(Color color, Color? borderColor) {
  return BoxDecoration(
    shape: BoxShape.circle,
    color: color,
    border: Border.all(color: borderColor ?? Colors.transparent),
    boxShadow: [
      BoxShadow(
        color: kGrey10Color.withOpacity(0.3),
        blurRadius: 25,
        spreadRadius: 8,
        offset: Offset(5, 3), // Shadow position
      ),
    ],
  );
}

BoxDecoration rounded(Color color) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    color: color,
    boxShadow: [
      BoxShadow(
        color: kGrey10Color.withOpacity(0.3),
        blurRadius: 25,
        spreadRadius: 8,
        offset: Offset(17, 3), // Shadow position
      ),
    ],
  );
}

BoxDecoration rounded2(Color color) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: color,
  );
}
