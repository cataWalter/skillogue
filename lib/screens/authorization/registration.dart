import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/screens/authorization/guided_registration.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/backend.dart';
import '../../utils/backend/authorization_backend.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  height: 300,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.white)),
                    labelText: 'Email',
                    hintText: 'Email',
                    labelStyle: textFieldStyleWithOpacity,
                    hintStyle: textFieldStyleWithOpacity,
                    filled: true,
                    fillColor: Colors.grey[850],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextField(
                  controller: controllerPassword,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.white)),
                    labelText: 'Password',
                    hintText: 'Password',
                    labelStyle: textFieldStyleWithOpacity,
                    hintStyle: textFieldStyleWithOpacity,
                    filled: true,
                    fillColor: Colors.grey[850],
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              TextButton(
                onPressed: doUserRegistration,
                child: Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
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
              ),
            ],
          ),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }

  void doUserRegistration() async {
    final email = controllerEmail.text.trim();
    controllerEmail.clear();
    final password = controllerPassword.text.trim();
    controllerPassword.clear();
    bool usersWithSameEmail = await existsUsersWithSameEmail(email);
    if (usersWithSameEmail) {
      databaseInsert('profile', {'email': email});
      //final AuthResponse res =
      await registration(email, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GuidedRegistration(email),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error!"),
            content: const Text(
                "The email is already associated with an existing account!"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
