import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/main/main_screen.dart';
import 'registration.dart';

class Login extends StatelessWidget {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login/Logout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: controllerUsername,
                enabled: !isLoggedIn,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Username',
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.blueGrey[400]),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: controllerPassword,
                enabled: !isLoggedIn,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Password',
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.blueGrey[400]),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: isLoggedIn ? null : () => doUserLogin(),
                  child: const Text('Login',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: !isLoggedIn ? null : () => doUserLogout(),
                  child: const Text('Logout',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                child: TextButton(
                  child: const Text("Don't have an account?",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();
    final user = ParseUser(username, password, null);
    var response = await user.login();
    if (response.success) {
      showSuccess("User was successfully login!");
      Profile loggedProfile = await queryByUsername(username);
      setState(() {
        isLoggedIn = true;
      });
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(loggedProfile),
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
}
