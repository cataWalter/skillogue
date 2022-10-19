import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AccountFinalization extends StatelessWidget {
  const AccountFinalization({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SignUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AccountFinalization_Helper(),
    );
  }
}

class AccountFinalization_Helper extends StatefulWidget {
  const AccountFinalization_Helper({super.key});

  @override
  _AccountFinalization_HelperState createState() =>
      _AccountFinalization_HelperState();
}

class _AccountFinalization_HelperState extends State<AccountFinalization_Helper> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: const Text('User registration',
                      style: TextStyle(fontSize: 16)),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerUsername,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Username'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'E-mail'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Password'),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 50,
                  child: TextButton(
                    child: const Text('Sign Up'),
                    onPressed: () => doUserRegistration(),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("User was successfully created!"),
          actions: <Widget>[
            new TextButton(
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
            new TextButton(
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

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser.createUser(username, password, email);

    var response = await user.signUp();

    if (response.success) {
      showSuccess();
    } else {
      showError(response.error!.message);
    }
  }
}
