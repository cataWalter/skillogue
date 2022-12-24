import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/screens/authorization/guided_registration.dart';
import 'package:skillogue/utils/misc_functions.dart';
import 'package:skillogue/widgets/my_text_field.dart';

import '../../main.dart';
import '../../utils/backend/authorization_backend.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

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
      body: Padding(
        padding: tabletMode ? tabletEdgeInsets : phoneEdgeInsets,
        child: listViewCreator(
          [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 300,
                child: Image.asset(
                  'assets/images/logo2.png',
                ),
              ),
            ),
            ListTile(
              title: MyTextField(
                  controllerEmail,
                  AppLocale.email.getString(context),
                  TextInputType.emailAddress,
                  Icons.email),
            ),
            ListTile(
              title: SizedBox(
                height: 50,
                child: TextField(
                  controller: controllerPassword,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  obscureText: true,
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
                    AppLocale.signUp.getString(context),
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

  void nextScreen(email, password) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GuidedRegistration(email, password),
      ),
    );
  }

  void doUserRegistration() async {
    final email = controllerEmail.text.trim();
    controllerEmail.clear();
    final password = controllerPassword.text.trim();
    controllerPassword.clear();
    bool noUsersSameEmail = await notExistsUsersWithSameEmail(email);
    if (noUsersSameEmail) {
      nextScreen(email, password);
    } else {
      existingEmail();
    }
  }

  existingEmail() {
    getBlurDialog(
      context,
      AppLocale.error.getString(context),
      AppLocale.alreadyAssociatedEmail.getString(context),
    );
  }
}
