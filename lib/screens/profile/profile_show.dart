import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/localization.dart';
import '../../utils/misc_functions.dart';

class ProfileShow extends StatelessWidget {
  final Profile profile;
  final bool showSettings;

  const ProfileShow(this.profile, this.showSettings, {super.key});

  @override
  Widget build(BuildContext context) {
    return !tabletMode
        ? Padding(
            padding: phoneEdgeInsets,
            child: listViewCreator(
              [
                Center(
                    child: getAvatar(
                        profile.name, profile.points, 60, 2.5, 1.1, 50)),
                Center(
                  child: Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                profileDescription(
                  profile,
                  20,
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  false,
                  true,
                ),
                chippyTitle(AppLocale.skills.getString(context)),
                chippyValues(profile.skills),
                chippyTitle(AppLocale.languages.getString(context)),
                chippyValues(profile.languages),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(children: [
              Expanded(
                child: listViewCreator(
                  [
                    Center(
                        child: getAvatar(
                            profile.name, profile.points, 60, 2.5, 1.1, 50)),
                    Row(
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    profileDescription(
                        profile,
                        20,
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        false,
                        false),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: listViewCreator(
                  [
                    chippyTitle(AppLocale.skills.getString(context)),
                    chippyValues(profile.skills),
                    chippyTitle(AppLocale.languages.getString(context)),
                    chippyValues(profile.languages),
                  ],
                ),
              ),
            ]),
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
        children: profileChippies(listValues, 16.0),
      ),
    );
  }
}
