import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/profile/profile_show.dart';

class ProfileOverview extends StatelessWidget {

  Profile profile;


  ProfileOverview(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          ProfileShow(profile),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
