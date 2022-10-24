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
