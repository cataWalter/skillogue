import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search_entity.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/checkboxes/profile/profile_country_checkbox.dart';
import 'package:skillogue/widgets/checkboxes/profile/profile_language_checkbox.dart';
import 'package:skillogue/widgets/checkboxes/profile/profile_skill_checkbox.dart';

class Settings extends StatelessWidget {
  Profile profile;

  Settings(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsHelper(profile),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }
}

class SettingsHelper extends StatefulWidget {
  Profile profile;
  Search search = Search();

  SettingsHelper(this.profile, {super.key});

  @override
  _SettingsHelperState createState() => _SettingsHelperState();
}

class _SettingsHelperState extends State<SettingsHelper> {
  final controllerCity = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerMinAge = TextEditingController();
  final controllerMaxAge = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    APP_NAME,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 40,
                    child: Image.asset(
                      'assets/images/logo - reduced.png',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  /*
                    Text(
                    "Welcome back                ",
                    style: GoogleFonts.bebasNeue(fontSize: 14),
                  ),
                  */
                  Text(
                    widget.profile.username,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
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
                          onPressed: putSkillDialog,
                          child: Text(
                            'My Skills',
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
                          onPressed: putLanguageDialog,
                          child: Text(
                            'my Languages',
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
                          onPressed: putCountryDialog,
                          child: Text(
                            'my country',
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

                  /*SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: putDialog,
                      child: const Text(
                        'Skills',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Languages',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Countries',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
              spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextField(
                    controller: controllerCity,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelText: 'Full Name',
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.blueGrey[400]),
                      filled: true,
                      fillColor: Colors.grey[850],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextField(
                    controller: controllerCity,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelText: 'Age',
                      hintText: 'Age',
                      hintStyle: TextStyle(color: Colors.blueGrey[400]),
                      filled: true,
                      fillColor: Colors.grey[850],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextField(
                    controller: controllerCity,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelText: 'City',
                      hintText: 'City',
                      hintStyle: TextStyle(color: Colors.blueGrey[400]),
                      filled: true,
                      fillColor: Colors.grey[850],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextField(
                    controller: controllerCity,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelText: 'Region',
                      hintText: 'Region',
                      hintStyle: TextStyle(color: Colors.blueGrey[400]),
                      filled: true,
                      fillColor: Colors.grey[850],
                    ),
                  ),
                ),
              ),
              spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 140.0),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: TextButton(
                      onPressed: putGenderDialog,
                      child: Text(
                        'Gender',
                        //style: TextStyle(color: Colors.white, fontSize: 30),
                        style: GoogleFonts.bebasNeue(
                            fontSize: 24,
                            color: Colors
                                .white), //GoogleFonts.openSans(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              spacer(),
              const SizedBox(
                height: 140,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: TextButton(
                      onPressed: updateProfileSettings,
                      child: Text(
                        'Save',
                        //style: TextStyle(color: Colors.white, fontSize: 30),
                        style: GoogleFonts.bebasNeue(
                            fontSize: 30,
                            color: Colors
                                .white), //GoogleFonts.openSans(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget spacer() {
    return const SizedBox(
      height: 30,
    );
  }

  void updateProfileSettings() async {
    Profile loggedProfile = await queryByUsername(widget.profile.username);
    var oldProfile = ParseObject('Profile')
      ..objectId = loggedProfile.objectId
      ..set('username', loggedProfile.username)
      ..set('fullName', loggedProfile.fullName)
      ..set('country', loggedProfile.country)
      ..set('city', loggedProfile.city)
      ..set('region', loggedProfile.region)
      ..set('gender', loggedProfile.gender)
      ..set('age', loggedProfile.age);
    await oldProfile.save();
  }

  void putSkillDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: skills.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: ProfileSkillCheckbox(skills[index], widget.profile),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void putLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      ProfileLanguageCheckbox(languages[index], widget.profile),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void putCountryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      ProfileCountryCheckbox(countries[index], widget.profile),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void putGenderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          content: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: genders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: ProfileCountryCheckbox(genders[index], widget.profile),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Profile> doUserSearch() {
    List<Profile> results = [];
    List<String> skills = [];
    // @TODO
    return results;
  }
}
