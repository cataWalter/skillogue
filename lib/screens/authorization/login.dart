import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/backend/authorization_backend.dart';
import '../../utils/backend/message_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  late Profile loggedProfile;

  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
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

  void doUserLogin() async {
    if (controllerUsername.text.trim().isEmpty ||
        controllerPassword.text.trim().isEmpty) {
      return;
    }
    String email = controllerUsername.text.trim();
    controllerUsername.clear();
    String password = controllerPassword.text.trim();
    controllerPassword.clear();
    //final AuthResponse res =
    await login(email, password);
    loggedProfile = await findProfileByEmail(email);
    loggedProfile.isLogged = true;
    loginDateUpdate(email);
    setState(() {
      isLoggedIn = true;
    });
    List<Conversation> c = await getMessagesAll(email);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          c,
          loggedProfile,
          ProfileSearch(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                controller: controllerUsername,
                enabled: !isLoggedIn,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Username',
                  hintText: 'Username',
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: TextField(
                controller: controllerPassword,
                enabled: !isLoggedIn,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Password',
                  hintText: 'Password',
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            TextButton(
              child: Container(
                height: 80,
                width: 300,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                if (isLoggedIn == false) {
                  doUserLogin();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
