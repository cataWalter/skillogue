import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:skillogue/utils/misc_functions.dart';

import '../utils/data.dart';

class Profile {
  String email;
  String name;
  String country;
  String city;
  String gender;
  int age;
  DateTime lastLogin;
  int points;
  List<String> languages;
  List<String> skills;

  List<String> blocked = [];
  List<String> blockedBy = [];

  Profile(this.email, this.name, this.country, this.city, this.gender, this.age,
      this.lastLogin, this.languages, this.skills, this.points);
}

evaluatePersonality(List<String> skills) {
  var res1 = [];
  double res2;
  for (var x in personalities) {
    res2 = 0.0;
    for (var y in skills) {
      res2 += personalityTraits[getElementIndex(x, personalities)]
          [getElementIndex(y, skills)];
    }
    res1.add(res2);
  }
  return personalities[getElementIndex(
      (res1.reduce((curr, next) => curr > next ? curr : next)), res1)];
}

Widget getAvatar(String name, int points, int radiusSize, double multiplier,
    double alignment, int starSize) {
  if (points < 200) {
    return randomAvatar(
      name,
      height: radiusSize.toDouble() * multiplier,
      width: radiusSize.toDouble() * multiplier,
    );
  } else {
    return Stack(
      alignment: Alignment(alignment, alignment),
      children: [
        randomAvatar(
          name,
          height: radiusSize.toDouble() * multiplier,
          width: radiusSize.toDouble() * multiplier,
        ),
        Icon(
          Icons.star,
          size: starSize.toDouble(),
          color: Colors.yellow,
        ),
      ],
    );
  }
}

Widget profileDescription(
    Profile p, int size, Color c, bool center, bool onRow) {
  if (onRow) {
    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(
              Icons.hiking,
              size: size.toDouble(),
              color: c,
            ),
            Text(
              evaluatePersonality(p.skills),
              style: TextStyle(
                fontSize: size.toDouble(),
                color: c,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.cake_outlined,
              size: size.toDouble(),
              color: c,
            ),
            Text(
              "${p.age}",
              style: TextStyle(
                fontSize: size.toDouble(),
                color: c,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: size.toDouble(),
              color: c,
            ),
            Text(
              p.city,
              style: TextStyle(
                fontSize: size.toDouble(),
                color: c,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.language,
              size: size.toDouble(),
              color: c,
            ),
            Text(
              p.country,
              style: TextStyle(
                fontSize: size.toDouble(),
                color: c,
              ),
            ),
          ],
        ),
      ],
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.cake_outlined,
              size: size.toDouble(),
              color: c,
            ),
            Text(
              "   ${p.age}",
              style: TextStyle(
                fontSize: size.toDouble(),
                color: c,
              ),
            ),
          ],
        ),
        addVerticalSpace(20),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: size.toDouble(),
              color: c,
            ),
            Text(
              "   ${p.city}",
              style: TextStyle(
                fontSize: size.toDouble(),
                color: c,
              ),
            ),
          ],
        ),
        addVerticalSpace(20),
        Row(
          children: [
            Icon(
              Icons.language,
              size: size.toDouble(),
              color: c,
            ),
            Text(
              "   ${p.country}",
              style: TextStyle(
                fontSize: size.toDouble(),
                color: c,
              ),
            ),
          ],
        ),
        addVerticalSpace(20),
        Row(
          children: [
            Icon(
              Icons.hiking,
              size: size.toDouble(),
              color: c,
            ),
            Expanded(
              child: Text(
                "   ${evaluatePersonality(p.skills)}",
                style: TextStyle(
                  fontSize: size.toDouble(),
                  color: c,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Comparator<Profile> sortById = (a, b) => b.lastLogin.compareTo(a.lastLogin);
