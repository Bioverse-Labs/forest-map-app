import 'package:flutter/material.dart';

class AppTheme {
  final mainTheme = ThemeData(
    primarySwatch: Colors.blue,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  ThemeData darkTheme;

  AppTheme() {
    this.darkTheme = mainTheme.copyWith(
      brightness: Brightness.dark,
    );
  }

  ThemeData get getMainTheme => mainTheme;
  ThemeData get getDarkTheme => darkTheme;

  InputDecoration inputDecoration(String label, {String placeholder}) =>
      InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(),
        hintText: placeholder,
      );
}
