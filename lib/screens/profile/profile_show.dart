import 'package:flutter/material.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/profile.dart';

class ProfileShow extends StatelessWidget {
  Profile profile;
  String emptyField = "";

  ProfileShow(this.profile, {super.key});

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
                initials(profile.fullName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                columnInfoType(profile.fullName, "Full Name"),
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
            color: Colors.white.withOpacity(0.35),
            fontSize: 12,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: getLightBlue(),
          ),
          child: Text(
            info,
            style: const TextStyle(
              color: Colors.white,
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
            color: Colors.white.withOpacity(0.35),
            fontSize: 12,
          ),
        ),
        Text(
          info,
          textAlign: a,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
