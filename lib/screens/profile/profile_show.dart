import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';

import '../../utils/misc_functions.dart';

class ProfileShow extends StatelessWidget {
  final Profile profile;
  final bool showSettings;

  const ProfileShow(this.profile, this.showSettings, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            getAvatar(
              profile.name,
              60,
              2.5,
            ),
            addVerticalSpace(10),
            Row(
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            addVerticalSpace(10),
            rowProfileInfo(
              profile,
              20,
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              false,
            ),
            addVerticalSpace(10),
            chippyTitle("Skills"),
            chippyValues(profile.skills),
            addVerticalSpace(5),
            chippyTitle("Languages"),
            chippyValues(profile.languages),
          ],
        ),
      ),
    );
  }

  Align chippyTitle(String listName) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        listName,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w100),
      ),
    );
  }

  Align chippyValues(List<String> listValues) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: chippies(listValues, 16.0),
      ),
    );
  }
}
