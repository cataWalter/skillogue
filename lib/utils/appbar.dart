import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../main.dart';
import '../screens/home_screen.dart';
import '../screens/profile/update_profile_info_screen.dart';
import 'constants.dart';

class ThisAppBar extends StatelessWidget {
  final String name;
  final bool showSettings;
  final _myBox = Hive.box("mybox");

  ThisAppBar(this.name, this.showSettings, {super.key});

  @override
  Widget build(BuildContext context) {
    return showSettings
        ? AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      appName,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),

              ],
            ),
            actions: [
              PopupMenuButton(
                color: Theme.of(context).scaffoldBackgroundColor,
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onSelected: (int item) {
                  switch (item) {
                    case 0:
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProfileInfoScreen(profile, profileSearch)));
                      }
                      break;
                    case 1:
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProfileInfoScreen(profile, profileSearch)));
                      }
                      break;
                    case 2:
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
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text(
                      "Update profile info",
                      style: TextStyle(),
                    ),
                  ),
                  /*PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Settings",
                          style: TextStyle(),
                        ),
                      ),*/
                  const PopupMenuItem(
                    value: 2,
                    child: Text(
                      "Log Out",
                      style: TextStyle(),
                    ),
                  ),
                ],
              ),
            ],
          )
        : AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      appName,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.bebasNeue(
                          fontSize: 24,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
