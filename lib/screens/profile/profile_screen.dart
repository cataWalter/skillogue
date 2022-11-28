import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/profile/profile_show.dart';
import 'package:skillogue/screens/profile/settings.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile;
  final List<Conversation> conversations;
  final ProfileSearch search;
  final _myBox = Hive.box("mybox");

  ProfileScreen(this.profile, this.conversations, this.search, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              toolbarHeight: 50,
              backgroundColor: Colors.black,
              actions: [
                PopupMenuButton(
                  onSelected: (int item) {
                    switch (item) {
                      case 0:
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Settings(profile, conversations, search)));
                        }
                        break;
                      case 1:
                        {
                          _myBox.delete(loggedProfileKey);
                          profile.isLogged = false;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp()));
                        }
                    }
                  },
                  color: myGrey,
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 0,
                      child: Text(
                        "Settings",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text(
                        "Log Out",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SingleChildScrollView(child: ProfileShow(profile)),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
