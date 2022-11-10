import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/search.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/authorization/login.dart';
import 'package:skillogue/screens/authorization/registration.dart';
import 'package:skillogue/screens/home_screen.dart';

class PreLogin extends StatefulWidget {
  const PreLogin({Key? key}) : super(key: key);

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  final Box _myBox = Hive.box("mybox");

  @override
  void initState() {
    super.initState();
    f();
  }

  f() async {
    if (_myBox.get(loggedProfileKey) != null) {
      Profile loggedProfile =
          await queryByUsername(_myBox.get(loggedProfileKey));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(loggedProfile, [], Search()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
              ),
              TextButton(
                child: Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      'Sign In',
                      //style: TextStyle(color: Colors.white, fontSize: 30),
                      style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          color: Colors
                              .white), //GoogleFonts.openSans(color: Colors.white),
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
              TextButton(
                child: Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      //style: TextStyle(color: Colors.white, fontSize: 30),
                      style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          color: Colors
                              .white), //GoogleFonts.openSans(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
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
    );
  }
}
