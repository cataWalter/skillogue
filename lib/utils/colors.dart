import 'dart:math';

import 'package:flutter/material.dart';

bool isDarkColor(Color myColor) {
  //return !(myColor.computeLuminance() < 0.250);
  return (myColor.computeLuminance() < 0.1);
}

Color getRandomDarkColor() {
  Color randomColor =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  if (isDarkColor(randomColor)) {
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
    filled: true,
    fillColor: Color.fromRGBO(20, 20, 20, 1.0), //<-- SEE HERE
  ),
);

const Color guidePrimary = Color(0xFF6200EE);
const Color guidePrimaryVariant = Color(0xFF3700B3);
const Color guideSecondary = Color(0xFF03DAC6);
const Color guideSecondaryVariant = Color(0xFF018786);
const Color guideError = Color(0xFFB00020);
const Color guideErrorDark = Color(0xFFCF6679);
const Color blueBlues = Color(0xFF174378);

const List<Color> rainbowColors = [
  Color.fromRGBO(255, 0, 0, 1),
  Color.fromRGBO(255, 127, 0, 1),
  Color.fromRGBO(210, 210, 0, 1),
  Color.fromRGBO(0, 255, 0, 1),
  Color.fromRGBO(0, 0, 255, 1),
  Color.fromRGBO(75, 0, 130, 1),
  Color.fromRGBO(148, 0, 211, 1),
];
