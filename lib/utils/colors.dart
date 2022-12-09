import 'dart:math';
import 'package:flutter/material.dart';

Color getRandomDarkColor() {
  Color randomColor =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  if (randomColor.computeLuminance() < 0.250) {
    return randomColor;
  } else {
    return getRandomDarkColor();
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true, //<-- SEE HERE
    fillColor: Color.fromRGBO(20, 20, 20, 1.0), //<-- SEE HERE
  ),
);
