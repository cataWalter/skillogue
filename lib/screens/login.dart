import 'package:flutter/material.dart';
import 'package:skillogue/routes/route.dart' as route;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pushNamed(context, route.homePage),
        ),
      ),
    );
  }
}
