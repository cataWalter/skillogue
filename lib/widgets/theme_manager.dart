import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  bool isDarkNow(){
    return _themeMode == ThemeMode.dark;
  }

  toggleDark() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  toggleLight() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
}