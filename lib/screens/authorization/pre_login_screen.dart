import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/screens/authorization/sign_in_screen.dart';
import 'package:skillogue/screens/authorization/sign_up_screen.dart';
import 'package:skillogue/utils/misc_functions.dart';

import '../../utils/localization.dart';

class PreLogin extends StatefulWidget {
  const PreLogin({Key? key}) : super(key: key);

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //addVerticalSpace(100),
                Image.asset(
                  'assets/images/logo2.png',
                ),
                TextButton(
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        AppLocale.signIn.getString(context),
                        style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                ),
                addVerticalSpace(30),
                TextButton(
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.teal[300]),
                    child: Center(
                      child: Text(
                        AppLocale.signUp.getString(context),
                        //context.getString("sign up"),
                        style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Registration(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
