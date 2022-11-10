import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/search.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/profile/profile_show.dart';
import 'package:skillogue/screens/profile/settings.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile;
  final List<Conversation> conversations;
  final Search search;
  final _myBox = Hive.box("mybox");

  ProfileScreen(this.profile, this.conversations, this.search, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Settings(profile, conversations, search)));
                  },
                  backgroundColor: Colors.black,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 8,
                        ),
                      )
                    ],
                  ),
                ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    _myBox.delete(loggedProfileKey);
                    profile.logged = false;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                  backgroundColor: Colors.black,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 8,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
