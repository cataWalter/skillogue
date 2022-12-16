import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/screens/authorization/guided_registration.dart';
import 'package:skillogue/utils/misc_functions.dart';
import 'package:skillogue/widgets/my_text_field.dart';

import '../../utils/backend/authorization_backend.dart';
import '../../utils/backend/misc_backend.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SizedBox(
                height: 300,
                child: Image.asset(
                  'assets/images/logo2.png',
                ),
              ),
            ),
            ListTile(
              title: MyTextField(controllerEmail, "Email", "Email",
                  TextInputType.emailAddress, Icons.email),
            ),
            ListTile(
              title: SizedBox(
                height: 50,
                child: TextField(
                  controller: controllerPassword,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : const Color.fromRGBO(235, 235, 235, 1),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        fontSize: 16, color: Theme.of(context).hintColor),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                        fontSize: 16, color: Theme.of(context).hintColor),
                    filled: true,
                    suffixIcon: const Icon(Icons.password),
                  ),
                ),
              ),
            ),
            addVerticalSpace(60),
            TextButton(
              onPressed: doUserRegistration,
              child: Container(
                height: 80,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextScreen(email) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GuidedRegistration(email),
      ),
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
      await registration(email, password);
      nextScreen(email);
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
