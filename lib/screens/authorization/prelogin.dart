import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/authorization/login.dart';
import 'package:skillogue/screens/authorization/registration.dart';
import 'package:skillogue/screens/home_screen.dart';

class PreLogin extends StatefulWidget {
  const PreLogin({Key? key}) : super(key: key);

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  final Box _myBox = Hive.box("mybox");

  @override
  void initState() {
    super.initState();
    autologinCheck();
  }

  autologinCheck() async {
    if (_myBox.get(loggedProfileKey) != null) {
      Profile loggedProfile =
          await queryByUsername(_myBox.get(loggedProfileKey));
      List<Conversation> c =
          await updateConversationsFromConvClass(_myBox.get(loggedProfileKey));
      ProfileSearch s = getOldSearch();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(loggedProfile, c, s),
        ),
      );
    }
  }

  ProfileSearch getOldSearch() {
    ProfileSearch oldSearch = ProfileSearch();
    if (_myBox.get(lastCountriesKey) != null) {
      oldSearch.countries = _myBox.get(lastCountriesKey);
    }
    if (_myBox.get(lastSkillsKey) != null) {
      oldSearch.skills = _myBox.get(lastSkillsKey);
    }
    if (_myBox.get(lastLanguagesKey) != null) {
      oldSearch.languages = _myBox.get(lastLanguagesKey);
    }
    if (_myBox.get(lastGendersKey) != null) {
      oldSearch.genders = _myBox.get(lastGendersKey);
    }
    if (_myBox.get(lastCityKey) != null) {
      oldSearch.city = _myBox.get(lastCityKey);
    }
    if (_myBox.get(lastMinAge) != null) {
      oldSearch.minAge = _myBox.get(lastMinAge);
    }
    else {
      oldSearch.minAge = 18;
    }
    if (_myBox.get(lastMaxAge) != null) {
      oldSearch.maxAge = _myBox.get(lastMaxAge);
    }
    else {
      oldSearch.maxAge = 99;
    }
    return oldSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
              ),
              TextButton(
                child: Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      'Sign In',
                      //style: TextStyle(color: Colors.white, fontSize: 30),
                      style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          color: Colors
                              .white), //GoogleFonts.openSans(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              ),
              TextButton(
                child: Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      //style: TextStyle(color: Colors.white, fontSize: 30),
                      style: GoogleFonts.bebasNeue(
                          fontSize: 30,
                          color: Colors
                              .white), //GoogleFonts.openSans(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Registration(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
