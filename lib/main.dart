import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:skillogue/screens/authorization/splash.dart';

import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/theme_manager.dart';

import 'package:skillogue/utils/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:skillogue/utils/backend/misc_backend.dart';
import 'package:provider/provider.dart' as provider;

ThemeManager themeManager = ThemeManager();


void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();

  //Hive
  await Hive.initFlutter();
  await Hive.openBox(localDatabase);

  //await Notifications().setup();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _myBox = Hive.box(localDatabase);

  @override
  void initState() {
    themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_myBox.get(darkModeKey) != null){
      bool darkModeEnabled = _myBox.get(darkModeKey);
      if (darkModeEnabled){
        themeManager.toggleDark();
      }
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeManager.themeMode,
        title: appName,
        home: const SplashScreen());
  }
}
