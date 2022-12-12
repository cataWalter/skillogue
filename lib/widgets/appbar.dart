import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/screens/authorization/pre_login.dart';
import 'package:skillogue/screens/profile/profile_settings.dart';

import '../screens/home_screen.dart';
import '../screens/profile/update_profile_info_screen.dart';
import '../utils/constants.dart';

class ThisAppBar extends StatelessWidget {
  final String name;
  final bool showSettings;
  final _myBox = Hive.box(localDatabase);

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
                                    UpdateProfileInfoScreen(profile)));
                      }
                      break;
                    case 1:
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileSettings()));
                      }
                      break;
                    case 2:
                      {
                        _myBox.delete(loggedProfileKey);
                        profile.isLogged = false;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PreLogin()));
                      }
                      break;
                    case 3:
                      {
                        print("suggest new skills");
                      }
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text(
                      "Update profile",
                      style: TextStyle(),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Settings",
                      style: TextStyle(),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text(
                      "Suggest new skills",
                      style: TextStyle(),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text(
                      "Logout",
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
