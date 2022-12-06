import 'package:flutter/material.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/profile.dart';

import '../../utils/colors.dart';
import '../../utils/utils.dart';

class ProfileShow extends StatelessWidget {
  Profile profile;

  ProfileShow(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: getRandomDarkColor(),
            child: Text(
              initials(profile.name),
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
          addVerticalSpace(20.0),
          Row(
            children: [
              Icon(Icons.person),
              Text(
                "   " + profile.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "      " + profile.age.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          addVerticalSpace(5.0),
          Row(
            children: [
              Icon(Icons.location_on_rounded),
              Text(
                "   " + profile.city + ", " + profile.country,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          addVerticalSpace(10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Skills",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w100),
            ),
          ),
          addVerticalSpace(10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: chippies(profile.skills, 20.0),
            ),
          ),
          addVerticalSpace(10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Languages",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w100),
            ),
          ),
          addVerticalSpace(10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: chippies(profile.languages, 20.0),
            ),
          ),
        ],
      ),
    );
  }


/*
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: getRandomDarkColor(),
              child: Text(
                initials(profile.name),
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                columnInfoType(profile.name, "Name"),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                profile.age >= 18 && profile.age <= 99
                    ? columnInfoType(profile.age.toString(), "Age")
                    : columnInfoType("", "Age"),
                const SizedBox(
                  height: 30,
                ),
                columnInfoType(profile.city, "City"),
              ],
            ),
            Column(
              children: [
                columnInfoType(profile.gender, "Gender"),
                const SizedBox(
                  height: 30,
                ),
                columnInfoType(profile.country, "Country"),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            columnAlignmentInfoType(
              formatList(profile.languages),
              "Languages",
              TextAlign.center,
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            columnAlignmentInfoType(
              formatList(profile.skills),
              "Skills",
              TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  String formatList(List<String> l) {
    if (l.isNotEmpty) {
      String res = l[0];
      for (int i = 1; i < l.length; i++) {
        res = "$res\n${l[i]}";
      }
      return res;
    }
    return emptyField;
  }

  Column columnInfoType(String info, String type) {
    if (info.isEmpty) {
      info = emptyField;
    }
    return Column(
      children: [
        Text(
          type,
          style: TextStyle(
            //color: getTextColor().withOpacity(0.75),
            fontSize: 14,
          ),
        ),
        Container(
          decoration: BoxDecoration(),
          child: Text(
            info,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Column columnAlignmentInfoType(String info, String type, TextAlign a) {
    if (info.isEmpty) {
      info = emptyField;
    }
    return Column(
      children: [
        Text(
          type,
          style: TextStyle(
            //color: getTextColor().withOpacity(0.75),
            fontSize: 14,
          ),
        ),
        Text(
          info,
          textAlign: a,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  */

}
