import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/main.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/widgets/mono_dropdown.dart';
import 'package:skillogue/widgets/my_text_field.dart';

import '../../utils/backend/profile_backend.dart';
import '../../utils/constants.dart';
import '../../utils/data.dart';
import '../../utils/localization.dart';
import '../../utils/misc_functions.dart';
import '../../widgets/multi_dropdown.dart';

class UpdateProfileInfoScreen extends StatefulWidget {
  final Profile profile;

  const UpdateProfileInfoScreen(this.profile, {super.key});

  @override
  State<UpdateProfileInfoScreen> createState() =>
      _UpdateProfileInfoScreenState();
}

class _UpdateProfileInfoScreenState extends State<UpdateProfileInfoScreen> {
  final controllerFullName = TextEditingController();
  final controllerAge = TextEditingController();

  List<String> selectedLanguages = [];
  List<String> selectedSkills = [];
  String selectedCountry = "";
  String selectedCity = "";
  String selectedGender = "";

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.profile.country;
    selectedCity = widget.profile.city;
    selectedGender = widget.profile.gender;
    selectedSkills = widget.profile.skills;
    selectedLanguages = widget.profile.languages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            updateLocalProfileSettings();
            updateDatabaseProfileSettings();
            profile = widget.profile;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(conversations, 0),
              ),
            );
          },
          icon: const Icon(Icons.save),
          label: Text(AppLocale.save.getString(context))),
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    appName,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    widget.profile.name,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 24,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: tabletMode
            ? tabletEdgeInsets
            : const EdgeInsets.symmetric(horizontal: 8.0),
        child: listViewCreator(
          [
            MyTextField(
                controllerFullName,
                widget.profile.name.isNotEmpty
                    ? widget.profile.name
                    : AppLocale.personalName.getString(context),
                TextInputType.text,
                Icons.person),
            MyTextField(
                controllerAge,
                widget.profile.age.toString().isNotEmpty &&
                        widget.profile.age <= 99
                    ? widget.profile.age.toString()
                    : AppLocale.age.getString(context),
                TextInputType.number,
                Icons.numbers),
            MonoDropdown(
              cities,
              AppLocale.city.getString(context),
              selectedCity,
              Icons.location_city,
              (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
            MonoDropdown(
              countries,
              AppLocale.country.getString(context),
              selectedCountry,
              Icons.flag,
              (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            MonoDropdown(
              genders,
              AppLocale.gender.getString(context),
              selectedGender,
              Icons.female,
              (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            MultiDropdown(
              skills,
              AppLocale.yourPassions.getString(context),
              AppLocale.skills.getString(context),
              selectedSkills,
              Icons.sports_tennis,
              (value) {
                setState(() {
                  selectedSkills = value;
                });
              },
            ),
            MultiDropdown(
              languages,
              AppLocale.yourLanguages.getString(context),
              AppLocale.languages.getString(context),
              selectedLanguages,
              Icons.abc,
              (value) {
                setState(() {
                  selectedLanguages = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateLocalProfileSettings() {
    if (selectedCountry.isNotEmpty) {
      widget.profile.country = selectedCountry;
    }
    if (selectedGender.isNotEmpty) {
      widget.profile.gender = selectedGender;
    }
    if (controllerFullName.text.isNotEmpty) {
      widget.profile.name = controllerFullName.text;
    }
    if (selectedLanguages.isNotEmpty) {
      widget.profile.languages = selectedLanguages;
    }
    if (selectedSkills.isNotEmpty) {
      widget.profile.skills = selectedSkills;
    }

    if (controllerAge.text.isNotEmpty) {
      int newAge = int.parse(controllerAge.text);
      if (newAge >= 18 && newAge <= 99) {
        widget.profile.age = newAge;
      }
    }
    if (selectedCity.isNotEmpty) {
      widget.profile.city = selectedCity;
    }
  }

  void updateDatabaseProfileSettings() async {
    var parameters = {};
    if (selectedCountry.isNotEmpty) {
      parameters.addAll({'country': selectedCountry});
    }
    if (selectedGender.isNotEmpty) {
      parameters.addAll({'gender': selectedGender});
    }
    if (selectedCity.isNotEmpty) {
      parameters.addAll({'city': selectedCity});
    }
    if (controllerFullName.text.isNotEmpty) {
      parameters.addAll({'name': controllerFullName.text});
    }
    if (selectedLanguages.isNotEmpty) {
      parameters.addAll({'languages': selectedLanguages});
    }
    if (selectedSkills.isNotEmpty) {
      parameters.addAll({'skills': selectedSkills});
    }
    if (controllerAge.text.isNotEmpty) {
      int newAge = int.parse(controllerAge.text);
      if (newAge >= 18 && newAge <= 99) {
        parameters.addAll({'age': newAge});
      }
    }
    updateProfile(widget.profile.email, parameters);
  }
}
