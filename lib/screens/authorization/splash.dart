import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:skillogue/screens/authorization/pre_login.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/backend/message_backend.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/utils/misc_functions.dart';

import '../../entities/conversation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _myBox = Hive.box(localDatabase);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(
          microseconds: 0,
        ), () async {
      getHome();
    });
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  addVerticalSpace(100),
                  Image.asset(
                    'assets/images/logo2.png',
                  ),
                  Text(
                    appName,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 80,
                      fontWeight: FontWeight.w300,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            /*Expanded(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "by",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 10,
                        fontWeight: FontWeight.w100,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Walter Catalfamo",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void nextScreenHome(c) async {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(c, 0)),
      );
    }
  }

  void nextScreenPreLogin() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PreLogin()),
    );
  }


  getHome() async {
    if (_myBox.get(loggedProfileKey) != null) {
      profile = await findProfileByEmail(_myBox.get(loggedProfileKey));
      List<Conversation> c = await getMessagesAll(_myBox.get(loggedProfileKey));
      //pause();
      nextScreenHome(c);
    } else {
      //pause();
      nextScreenPreLogin();
    }
  }
}
