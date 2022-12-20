import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class Profile {
  String email;
  String name;
  String country;
  String city;
  String gender;
  int age;
  DateTime lastLogin;
  Color color;
  int? points;
  List<String> languages;
  List<String> skills;

  List<String> blocked = [];

  List<String> blockedBy = [];

  Profile(this.email, this.name, this.country, this.city, this.gender, this.age,
      this.lastLogin, this.color, this.languages, this.skills);
}

getAvatar(String name, int radiusSize, double multiplier) {
  /*return CircleAvatar(
    radius: radiusSize.toDouble(),
    backgroundColor: color,
    child: Text(
      initials(name),
      style: TextStyle(
        fontSize: fontSize.toDouble(),
        color: Colors.white,
      ),
    ),
  );*/
  return randomAvatar(
    name,
    height: radiusSize.toDouble() * multiplier,
    width: radiusSize.toDouble() * multiplier,
  );
}

Row rowProfileInfo(Profile p, int size, Color c, bool center) {
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
        "  ${p.age}  ",
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
        " ${p.city}  ",
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
        " ${p.country}",
        style: TextStyle(
          fontSize: size.toDouble(),
          color: c,
        ),
      ),
    ],
  );
}

Comparator<Profile> sortById = (a, b) => b.lastLogin.compareTo(a.lastLogin);
