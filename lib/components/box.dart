import 'package:flutter/material.dart';

BoxDecoration boxNoColor(Color borderColor, double borderWidth) {
  return BoxDecoration(
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
  );
}

BoxDecoration boxWithColor(Color color, Color borderColor, double borderWidth) {
  return BoxDecoration(
    color: color,
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
  );
}
