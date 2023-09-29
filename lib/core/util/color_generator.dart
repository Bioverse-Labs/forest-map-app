import 'package:flutter/material.dart';

MaterialColor materialColorFromHex(int hex, {int? light, int? dark}) {
  Map<int, Color> color = {
    50: Color(light ?? hex),
    100: Color(light ?? hex),
    200: Color(light ?? hex),
    300: Color(hex),
    400: Color(hex),
    500: Color(hex),
    600: Color(hex),
    700: Color(dark ?? hex),
    800: Color(dark ?? hex),
    900: Color(dark ?? hex),
  };

  return MaterialColor(
    Color(hex).value,
    color,
  );
}
