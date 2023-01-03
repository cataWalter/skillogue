import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:skillogue/entities/profile_entity.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter In-App Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
      builder: InAppNotifications.init(),
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

_resetStyle() {
  InAppNotifications.instance
    ..titleFontSize = 14.0
    ..descriptionFontSize = 11.0
    ..textColor = Colors.white
    ..backgroundColor = Colors.black
    ..shadow = true
    ..animationStyle = InAppNotificationsAnimationStyle.scale;
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter In-App Notifications'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 50.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                _resetStyle();
                InAppNotifications.show(
                    title: 'Welcome to InAppNotifications',
                    description:
                    'This is a very simple notification without any leading or ending widgets.',
                    onTap: () {},
                    persistent: true);
              },
              child: const Text("Show Simple Notification"),
            ),
            TextButton(
              onPressed: () {
                _resetStyle();

                InAppNotifications.show(
                    title: 'Welcome to InAppNotifications',
                    leading: const Icon(
                      Icons.fact_check,
                      size: 50,
                    ),
                    description:
                    'This is a very simple notification with leading widget.',
                    onTap: () {});
              },
              child: const Text("Show Notification with Leading widget"),
            ),
            TextButton(
              onPressed: () {
                _resetStyle();
                InAppNotifications.show(
                  title: 'Walter Catalfamo',
                  leading: getAvatar("Walter Catalfamo", 10000, 50, 1, 1, 20),
                  description:
                  'Ciao compare come stai?',
                  onTap: () {

                  },
                );
              },
              child: const Text(
                  "Show Notification with Leading and Ending widget"),
            ),
            TextButton(
              onPressed: () {
                InAppNotifications.instance
                  ..backgroundColor = Colors.orange
                  ..textColor = Colors.purple;

                InAppNotifications.show(
                  title: 'Welcome to InAppNotifications',
                  leading: const Icon(
                    Icons.fact_check,
                    color: Colors.green,
                    size: 50,
                  ),
                  ending: const Icon(
                    Icons.arrow_right_alt,
                    color: Colors.red,
                  ),
                  description:
                  'This is a very simple notification with leading widget.',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                );
              },
              child: const Text("Show Customized Notification"),
            ),
          ],
        ),
      ),
    );
  }
}