import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/authorization/prelogin.dart';
import 'package:skillogue/screens/settings.dart';
import 'package:skillogue/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  Profile profile;

  ProfileScreen(this.profile, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    username = widget.profile.username;
  }

  late String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          Center(
            child: CircleAvatar(
              radius: 24,
              backgroundColor: getRandomDarkColor(),
              child: Text(
                "NC",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          linea(),

          // GENDER + FULL NAME + AGE
          characteristics(Icons.face, 'full name + age'),

          const SizedBox(height: 30.0),

          // CITY, REGION, COUNTRY
          characteristics(Icons.location_city, 'city, region, country'),

          const SizedBox(height: 30.0),

          // LANGUAGE
          characteristics(Icons.spatial_audio_off, 'language'),

          const SizedBox(height: 30.0),

          // LAST LOGIN
          characteristics(Icons.update, 'last_login'),

          linea(),

          // skill - categoria - nivel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                // skill
                children: [
                  const Text(
                    'SKILLS',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  skills('swim'),
                  const SizedBox(height: 12.0),
                  skills('draw'),
                ],
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                // categoria
                children: [
                  const Text(
                    'CATEGORY',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  skills('Sport'),
                  const SizedBox(height: 12.0),
                  skills('Creativity'),
                ],
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                // categoria
                children: [
                  const Text(
                    'NIVEL',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  getThirdText(4),
                  const SizedBox(height: 10.0),
                  getThirdText(0),
                ],
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        //style: TextStyle(color: Colors.white, fontSize: 30),
                        style: GoogleFonts.bebasNeue(
                            fontSize: 18,
                            color: Colors
                                .white), //GoogleFonts.openSans(color: Colors.white),
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
                        //style: TextStyle(color: Colors.white, fontSize: 30),
                        style: GoogleFonts.bebasNeue(
                            fontSize: 18,
                            color: Colors
                                .white), //GoogleFonts.openSans(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  } //results

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

  linea() {
    return Divider(
      height: 60.0,
      color: Colors.blueGrey[400],
      endIndent: 20.0,
      indent: 20.0,
      thickness: 1,
    );
  }

  skills(String skill) {
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
