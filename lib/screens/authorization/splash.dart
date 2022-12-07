import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/screens/authorization/prelogin.dart';

import '../../entities/conversation.dart';
import '../../entities/profile.dart';
import '../../entities/profile_search.dart';
import '../../utils/backend/message_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/constants.dart';
import '../home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final Box _myBox = Hive.box("mybox");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    f();
  }

  f() async {
    if (_myBox.get(loggedProfileKey) != null) {
      Profile loggedProfile =
          await findProfileByEmail(_myBox.get(loggedProfileKey));
      List<Conversation> c = await getMessagesAll(_myBox.get(loggedProfileKey));
      ProfileSearch s = getOldSearch();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(c, loggedProfile, s),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PreLogin(),
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
    if (_myBox.get(lastMaxAge) != null) {
      oldSearch.maxAge = _myBox.get(lastMaxAge);
    }
    return oldSearch;
  }
}
