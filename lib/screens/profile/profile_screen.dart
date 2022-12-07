import 'package:flutter/material.dart';

import 'package:skillogue/screens/profile/profile_show.dart';

import '../home_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SingleChildScrollView(child: ProfileShow(profile, true)),
      ),
    );
  }
}
