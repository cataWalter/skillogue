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
              Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      columnInfoType(widget.profile.fullName, "Full Name"),
                    ],
                  ),
                ],
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.blueGrey[800],
                                  content: const SizedBox(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    child: Text("ueueue"),
                                  ),
                                );
                              },
                            );
                          },
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

  Column columnInfoType(String info, String type) {
    if (info.isEmpty) {
      info = emptyField;
    }
    return Column(
      children: [
        Row(
          children: [
            Text(
              type,
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 10,
                  ),
                  onPressed: () {},
                  //child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
        Text(
          info,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
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
}
