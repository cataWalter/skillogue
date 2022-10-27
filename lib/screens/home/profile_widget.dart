import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/authorization/prelogin.dart';
import 'package:skillogue/screens/settings.dart';
import 'package:skillogue/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;

  const ProfileScreen(this.profile, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    username = widget.profile.username;
    fullName = widget.profile.fullName;
    country = widget.profile.country;
    city = widget.profile.city;
    age = widget.profile.age;
    languages = widget.profile.languages;
    skills = widget.profile.skills;
    gender = widget.profile.gender;
  }

  late final String username;
  late final String fullName;
  late final String country;
  late final String city;
  late final String region;
  late final int age;
  late final String gender;

  late final List<String> languages;
  late final List<String> skills;
  String emptyField = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: getRandomDarkColor(),
                      child: Text(
                        initials(fullName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    columnInfoType(widget.profile.fullName, "Full Name"),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    columnInfoType(widget.profile.age.toString(), "Age"),
                    columnInfoType(widget.profile.city, "City"),
                    columnInfoType(widget.profile.country, "Country"),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  columnAlignmentInfoType(
                    formatList(widget.profile.skills),
                    "Skills",
                    TextAlign.start,
                  ),
                  columnAlignmentInfoType(
                    formatList(widget.profile.languages),
                    "Languages",
                    TextAlign.end,
                  ),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Settings(widget.profile)));
                          },
                          child: Text(
                            'Settings',
                            style: GoogleFonts.bebasNeue(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Suggestions',
                            style: GoogleFonts.bebasNeue(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PreLogin()));
                          },
                          child: Text(
                            'Log Out',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )
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

  getIcon(IconData icono) {
    return Icon(
      icono,
      color: Colors.blueGrey[400],
    );
  }

  characteristics(IconData myIcon, String datoEnCuestion) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 20.0),
        getIcon(myIcon),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          datoEnCuestion,
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  characteristics2(IconData myIcon, List<String> datoEnCuestion) {
    String listJoin = datoEnCuestion.join(" ,");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 20.0),
        getIcon(myIcon),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          listJoin,
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
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
            fontSize: 8,
          ),
        ),
        Text(
          info,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
            fontSize: 8,
          ),
        ),
        Text(
          info,
          textAlign: a,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  toSkills(String skill) {
    return Text(
      skill,
      style: TextStyle(
        color: Colors.blueGrey[400],
        letterSpacing: 2.0,
      ),
    );
  }

  Text getThirdText(int n) {
    if (n == 0) {
      return const Text(
        "",
        style: TextStyle(color: Colors.greenAccent),
      );
    }
    String res = '★';
    while (n != 1) {
      res = '$res★';
      n--;
    }
    return Text(
      res,
      style: const TextStyle(color: Colors.greenAccent),
    );
  }
}

initials(String fullName) {
  if (fullName.isEmpty) {
    return "";
  }
  String fName = fullName.substring(0, 1).toUpperCase();
  int indexSpace = fullName.indexOf(" ");
  if (indexSpace != -1) {
    String fSurname =
        fullName.substring(indexSpace, indexSpace + 1).toUpperCase();
    return fName + fSurname;
  } else {
    return fName;
  }
}
