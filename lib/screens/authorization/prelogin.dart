import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/authorization/login.dart';
import 'package:skillogue/screens/authorization/registration.dart';

class PreLogin extends StatefulWidget {
  const PreLogin({Key? key}) : super(key: key);

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("willpop3");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
        return false;
      },

      child: Scaffold(
        //backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: TextButton(
                        child: Text(
                          'Sign In',
                          //style: TextStyle(color: Colors.white, fontSize: 30),
                          style: GoogleFonts.bebasNeue(
                              fontSize: 30,
                              color: Colors
                                  .white), //GoogleFonts.openSans(color: Colors.white),
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
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.teal.shade300,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: TextButton(
                        child: Text(
                          'Sign Up',
                          //style: TextStyle(color: Colors.white, fontSize: 30),
                          style: GoogleFonts.bebasNeue(
                              fontSize: 30,
                              color: Colors
                                  .white), //GoogleFonts.openSans(color: Colors.white),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
