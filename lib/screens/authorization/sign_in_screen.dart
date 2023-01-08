import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/utils/localization.dart';

import '../../entities/conversation_entity.dart';
import '../../entities/profile_entity.dart';
import '../../utils/backend/authorization_backend.dart';
import '../../utils/backend/message_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/constants.dart';
import '../../utils/misc_functions.dart';
import '../../utils/responsive_layout.dart';
import '../home_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  late Profile loggedProfile;
  bool obscurePassword = true;

  void doUserLogin() async {
    if (controllerEmail.text.trim().isEmpty ||
        controllerPassword.text.trim().isEmpty) {
      return;
    }
    String email = controllerEmail.text.trim();
    controllerEmail.clear();
    String password = controllerPassword.text.trim();
    controllerPassword.clear();
    try {
      await login(email, password);
      loggedProfile = await findProfileByEmail(email);
      loginDateUpdate(email);
      List<Conversation> c = await getMessagesAll(email);
      nextScreen(c);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void nextScreen(c) async {
    profile = loggedProfile;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(c, 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Padding(
          padding: phoneEdgeInsets,
          child: loginList(),
        ),
        tabletBody: Padding(
          padding: tabletEdgeInsets,
          child: loginList(),
        ),
        desktopBody: Padding(
          padding: desktopEdgeInsets,
          child: loginList(),
        ),
      ),
    );
  }

  loginList() {
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
            key: Key("email"),
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
              hintStyle:
                  TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
              filled: true,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: TextField(
            key: Key("pass"),
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
              labelStyle:
                  TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
              hintText: 'Password',
              hintStyle:
                  TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
              filled: true,
              suffix: obscurePassword
                  ? TextButton(
                key: Key("show"),

                onPressed: () {
                        setState(() {
                          obscurePassword = false;
                        });
                      },
                      child: const Text("Show"),
                    )
                  : TextButton(
                key: Key("show"),

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
          key: Key("login"),
          child: Container(
            height: 80,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                'Sign In',
                style: GoogleFonts.bebasNeue(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onPressed: () {
            doUserLogin();
          },
        ),
      ],
    );
  }
}
