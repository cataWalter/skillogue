import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/constants.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/profile/profile_show.dart';
import 'package:skillogue/screens/profile/settings.dart';

class ProfileScreen extends StatefulWidget {
  Profile profile;

  ProfileScreen(this.profile, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Box _myBox = Hive.box("mybox");

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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Settings(widget.profile)));
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
                  onPressed: () {
                    _myBox.delete(loggedProfileKey);
                    setState(() {
                      widget.profile.logged = false;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
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
          ProfileShow(widget.profile),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
