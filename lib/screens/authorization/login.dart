import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/constants.dart';

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
  final _myBox = Hive.box("mybox");

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

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
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

  void doUserLogin(String username, String password) async {
    final user = ParseUser(username, password, null);
    var response = await user.login();
    if (response.success) {
      //showSuccess("User was successfully login!");
      loggedProfile = await queryByUsername(username);
      _myBox.put(loggedProfileKey, username);
      loggedProfile.logged = true;
      var oldProfile = ParseObject('Profile')
        ..objectId = loggedProfile.objectId
        ..set('lastLogin', DateTime.now());
      await oldProfile.save();
      setState(() {
        isLoggedIn = true;
      });
      if (!mounted) return;
      List<Conversation> c = await updateConversationsFromConvClass(username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(loggedProfile, c, Search()),
        ),
      );
    } else {
      showError(response.error!.message);
    }
  }

  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();
    if (response.success) {
      showSuccess("User was successfully logout!");
      setState(() {
        isLoggedIn = false;
      });
    } else {
      showError(response.error!.message);
    }
  }

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
                  controller: controllerUsername,
                  enabled: !isLoggedIn,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.white)),
                    labelText: 'Username',
                    hintText: 'Username',
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
                  enabled: !isLoggedIn,
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
                child: Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
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
                  if (isLoggedIn == false) {
                    doUserLogin(controllerUsername.text.trim(),
                        controllerPassword.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }
}
