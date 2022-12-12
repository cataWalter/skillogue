import 'package:flutter/material.dart';
import 'package:skillogue/utils/colors.dart';

import '../utils/misc_functions.dart';

class Profile {
  String email;
  String name;
  String country;
  String city;
  String gender;
  int age;
  DateTime lastLogin;
  Color color;

  List<String> languages;
  List<String> skills;

  Profile(this.email, this.name, this.country, this.city, this.gender, this.age,
      this.lastLogin, this.color, this.languages, this.skills);

  late bool isLogged;

  bool isEmptyProfile() {
    return name.isEmpty ||
        country.isEmpty ||
        city.isEmpty ||
        gender.isEmpty ||
        age.toString().isEmpty ||
        skills.isEmpty ||
        languages.isEmpty;
  }
}

CircleAvatar getAvatar(String name, Color color, int radiusSize, int fontSize) {
  return CircleAvatar(
    radius: radiusSize.toDouble(),
    backgroundColor: color,
    child: Text(
      initials(name),
      style: TextStyle(
        fontSize: fontSize.toDouble(),
        color: isDarkColor(color) ? Colors.black : Colors.white,
      ),
    ),
  );
}

Row rowProfileInfo(Profile profile, int size, Color c, bool center) {
  return Row(
    mainAxisAlignment:
        center ? MainAxisAlignment.center : MainAxisAlignment.start,
    children: [
      Icon(
        Icons.cake_outlined,
        size: size.toDouble(),
        color: c,
      ),
      Text(
        "  ${profile.age}  ",
        style: TextStyle(
          fontSize: size.toDouble(),
          color: c,
        ),
      ),
      Icon(
        Icons.location_on_outlined,
        size: size.toDouble(),
        color: c,
      ),
      Text(
        " ${profile.city}  ",
        style: TextStyle(
          fontSize: size.toDouble(),
          color: c,
        ),
      ),
      Icon(
        Icons.language,
        size: size.toDouble(),
        color: c,
      ),
      Text(
        " ${profile.country}",
        style: TextStyle(
          fontSize: size.toDouble(),
          color: c,
        ),
      ),
    ],
  );
}

Comparator<Profile> sortById = (a, b) => b.lastLogin.compareTo(a.lastLogin);
