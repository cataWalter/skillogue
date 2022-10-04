import 'package:flutter/material.dart';
import 'package:skillogue/routes/route.dart' as route;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Hello, oflutter.com'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings),
        onPressed: () => Navigator.pushNamed(context, route.settingsPage),
      ),
    );
  }
}
