import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/screens/profile/profile_screen.dart';

class ProfileOverview extends StatelessWidget {
  final Profile profile;

  const ProfileOverview(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ProfileScreen(profile, false),
    );
  }
}
