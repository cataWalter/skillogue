import 'dart:math';
import 'dart:ui';

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
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Color.fromRGBO(20, 20, 20, 1.0),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true, //<-- SEE HERE
    fillColor: Color.fromRGBO(20, 20, 20, 1.0), //<-- SEE HERE
  ),

);

/*Color getLightBlue() {
  return const Color.fromRGBO(179, 217, 248, 0);
}

Color getBackgroundColor() {
  if (darkMode == true) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

Color getTextFieldBackgroundColor(){
  if (darkMode == true) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

Color getTextColor() {
  if (darkMode == true) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

Color getReversedTextColor() {
  if (darkMode == true) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

*/
