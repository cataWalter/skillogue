import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/widgets/mono_dropdown.dart';
import 'package:skillogue/widgets/my_text_field.dart';

import '../../utils/backend/profile_backend.dart';
import '../../utils/data.dart';
import '../../utils/misc_functions.dart';
import '../../widgets/appbar.dart';
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
        label: const Text("Save"),
      ),
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: ThisAppBar(widget.profile.name, false),
      ),
      body: listViewCreator(
        [
          MyTextField(
              controllerFullName,
              widget.profile.name.isNotEmpty
                  ? widget.profile.name
                  : "Full Name",
              TextInputType.text,
              Icons.person),
          MyTextField(
              controllerAge,
              widget.profile.age.toString().isNotEmpty &&
                      widget.profile.age <= 99
                  ? widget.profile.age.toString()
                  : "Age",
              TextInputType.number,
              Icons.numbers),
          MonoDropdown(
            cities,
            "City",
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
            "Country",
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
            "Gender",
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
            "What are your passions?",
            "Skills",
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
            "What languages do you speak?",
            "Languages",
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
    );
  }

  String? validateName(String s) {
    if (s == "error") {
      return "error1";
    } else {
      return null;
    }
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

  String capitalizeFirstLetterString(String s) {
    return "${s[0].toUpperCase()}${s.substring(1).toLowerCase()}";
  }

  String dropdownCountry() {
    if (widget.profile.country.isNotEmpty) {
      return widget.profile.country;
    } else {
      return "";
    }
  }
}
