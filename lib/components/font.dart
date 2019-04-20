import 'package:flutter/material.dart';

TextStyle normalFont(double size) {
  return TextStyle(fontSize: size);
}

TextStyle normalColorFont(double size, Color color) {
  return TextStyle(fontSize: size, color: color);
}

TextStyle boldFont(double size) {
  return TextStyle(fontSize: size, fontWeight: FontWeight.bold);
}

TextStyle boldColorFont(double size, Color color) {
  return TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: color);
}

TextStyle ccNumberColorFont(double size, Color color) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color,
    fontFamily: 'Bitstream',
    letterSpacing: 2.0,
  );
}

TextStyle ccNameColorFont(double size, Color color) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color,
    fontFamily: 'Bitstream',
    letterSpacing: 2.0,
    wordSpacing: 4.0,
  );
}
