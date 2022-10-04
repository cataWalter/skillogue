import 'package:flutter/material.dart';
import 'package:skillogue/screens/home.dart';
import 'package:skillogue/screens/login.dart';
import 'package:skillogue/screens/settings_page.dart';

const String loginPage = 'login';
const String homePage = 'home';
const String settingsPage = 'settings';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case homePage:
      return MaterialPageRoute(builder: (context) => HomePage());
    case settingsPage:
      return MaterialPageRoute(builder: (context) => SettingsPage());
    default:
      throw ('This route name does not exit');
  }
}
