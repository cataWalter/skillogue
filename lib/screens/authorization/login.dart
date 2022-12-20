import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/widgets/my_text_field.dart';

import '../../entities/conversation.dart';
import '../../entities/profile.dart';
import '../../utils/backend/authorization_backend.dart';
import '../../utils/backend/message_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/misc_functions.dart';
import '../home_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  late Profile loggedProfile;

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
    loginDateUpdate(email);
    List<Conversation> c = await getMessagesAll(email);
    nextScreen(c);
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
      body: listViewCreator(
        [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 300,
              child: Image.asset(
                'assets/images/logo2.png',
              ),
            ),
          ),
          MyTextField(
              controllerUsername, 'Username', TextInputType.text, Icons.person),
          SizedBox(
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
                labelStyle:
                    TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
                hintText: 'Password',
                hintStyle:
                    TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
                filled: true,
                suffixIcon: const Icon(Icons.password),
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
      ),
    );
  }
}
