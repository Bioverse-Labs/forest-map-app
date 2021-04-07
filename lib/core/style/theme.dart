import 'package:flutter/material.dart';

class AppTheme {
  final mainTheme = ThemeData(
    primarySwatch: Colors.blue,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.tealAccent,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  ThemeData get getMainTheme => mainTheme;
  ThemeData get getDarkTheme => darkTheme;

  InputDecoration inputDecoration(String label, {String placeholder}) =>
      InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(),
        hintText: placeholder,
      );
}
