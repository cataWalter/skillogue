import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/screens/login.dart';
import 'package:skillogue/screens/registration.dart';

class PreLogin extends StatefulWidget {
  const PreLogin({Key? key}) : super(key: key);

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
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
              /*Icon(Icons.phone_android),
              SizedBox(height: 10),
              Text("Hello",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 54,
                  )
                  //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
              SizedBox(height: 10),
              Text(
                "Hello",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "email"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                  ),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "password",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),*/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: EdgeInsets.all(20),
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
                          new MaterialPageRoute(
                            builder: (context) => new LoginPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: EdgeInsets.all(20),
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
                          new MaterialPageRoute(
                            builder: (context) => new RegistrationPage(),
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
    );
  }
}
