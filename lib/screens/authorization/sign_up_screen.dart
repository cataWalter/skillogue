import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/screens/authorization/guided_registration_screen.dart';

import '../../utils/backend/authorization_backend.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/misc_functions.dart';
import '../../utils/responsive_layout.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Padding(
          padding: phoneEdgeInsets,
          child: registrationList(),
        ),
        tabletBody: Padding(
          padding: tabletEdgeInsets,
          child: registrationList(),
        ),
        desktopBody: Padding(
          padding: desktopEdgeInsets,
          child: registrationList(),
        ),
      ),
    );
  }

  registrationList(){
    return listViewCreator(
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
        SizedBox(
          height: 50,
          child: TextField(
            controller: controllerEmail,
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
              hintText: AppLocale.email.getString(context),
              hintStyle: TextStyle(
                  fontSize: 16, color: Theme.of(context).hintColor),
              filled: true,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controllerPassword,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            obscureText: obscurePassword,
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
              suffix: obscurePassword
                  ? TextButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = false;
                  });
                },
                child: const Text("Show"),
              )
                  : TextButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = true;
                  });
                },
                child: const Text("Hide"),
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
