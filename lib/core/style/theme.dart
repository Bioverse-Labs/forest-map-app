import 'package:flutter/material.dart';

import '../util/color_generator.dart';

class AppTheme {
  final mainTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: materialColorFromHex(0xff1D2D43),
    buttonTheme: ButtonThemeData(
      buttonColor: materialColorFromHex(0xff1D2D43),
      textTheme: ButtonTextTheme.primary,
    ),
  );

  final darkTheme = ThemeData.dark(useMaterial3: false).copyWith(
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.tealAccent,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  ThemeData get getMainTheme => mainTheme;
  ThemeData get getDarkTheme => darkTheme;

  InputDecoration inputDecoration(
    String label, {
    String? placeholder,
    String? suffixText,
    String? helperText,
  }) =>
      InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(),
        hintText: placeholder,
        suffixText: suffixText,
        helperText: helperText,
      );
}
