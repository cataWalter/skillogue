import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:skillogue/screens/authorization/splash_screen.dart';
import 'package:skillogue/utils/backend/misc_backend.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/utils/localization.dart';
import 'package:skillogue/widgets/theme_manager.dart';

ThemeManager themeManager = ThemeManager();

final FlutterLocalization localizator = FlutterLocalization.instance;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  // The first language is your default language.

  //Hive
  await Hive.initFlutter();
  await Hive.openBox(localDatabase);
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
    localizator.init(
      mapLocales: [
        const MapLocale('en', AppLocale.en),
        const MapLocale('it', AppLocale.it),
        const MapLocale('scn', AppLocale.scn),
      ],
      initLanguageCode: 'en',
    );
    localizator.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_myBox.get(darkModeKey) != null) {
      try {
        bool darkModeEnabled = _myBox.get(darkModeKey);
        if (darkModeEnabled) {
          themeManager.toggleDark();
        }
      } catch (e) {}
    }
    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      supportedLocales: localizator.supportedLocales,
      localizationsDelegates: localizator.localizationsDelegates,
      builder: InAppNotifications.init(),
    );
  }
}
