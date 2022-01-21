import 'package:flutter/material.dart';

class Tingsapp {
  static const primary = Color(0xFFFFA500);
  static const lightOrange = Color(0xFFFFE0B2);
  static const grey = Color(0xFFE0E0E0);
  static const bgColor = Color(0xF8FAF8);
  static const inActive = Color(0xFFFFE4B3);
  static const fontColor = Color(0xFF696969);
  static const transparent = Colors.transparent;

//graph related colors
  static const received = Color(0xffffa500);
  static const pending = Color(0xffffb833);
  static const accepted = Color(0xffffc966);
  static const declined = Color(0xffffdb99);
  static const completed = Color(0xffffedcc);
}

MaterialColor swatchify() {
  return MaterialColor(0xFFFFA500, const <int, Color>{
    50: const Color(0xFFFFA500),
    100: const Color(0xFFFFA500),
    200: const Color(0xFFFFA500),
    300: const Color(0xFFFFA500),
    400: const Color(0xFFFFA500),
    500: const Color(0xFFFFA500),
    600: const Color(0xFFFFA500),
    700: const Color(0xFFFFA500),
    800: const Color(0xFFFFA500),
    900: const Color(0xFFFFA500)
  });
}
