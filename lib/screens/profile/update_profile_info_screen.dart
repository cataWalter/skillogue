import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/widgets/my_multi_select_field.dart';
import 'package:skillogue/widgets/my_text_field.dart';
import 'package:skillogue/widgets/my_uni_select_field.dart';

import '../../utils/backend/profile_backend.dart';
import '../../utils/data.dart';
import '../../utils/misc_functions.dart';
import '../../widgets/appbar.dart';

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

  //String selectedGender = "";

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
              builder: (context) => Home(conversations),
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
              'Full Name',
              widget.profile.name.isNotEmpty
                  ? widget.profile.name
                  : "Full Name",
              TextInputType.text,
              Icons.person),
          MyTextField(
              controllerAge,
              'Age',
              widget.profile.age.toString().isNotEmpty &&
                      widget.profile.age <= 99
                  ? widget.profile.age.toString()
                  : "Age",
              TextInputType.number,
              Icons.numbers),
          MyUniSelectField(
              cities,
              "City",
              'City',
              widget.profile.city.isNotEmpty ? widget.profile.city : "City",
              selectedCity,
              Icons.location_city),
          MyUniSelectField(
            countries,
            "Country",
            "Country",
            widget.profile.country.isNotEmpty
                ? widget.profile.country
                : selectedCountry,
            selectedCountry,
            Icons.flag,
          ),
          MyUniSelectField(
            genders,
            "Gender",
            "Gender",
            widget.profile.gender.isNotEmpty
                ? widget.profile.gender
                : selectedGender,
            selectedGender,
            Icons.female,
          ),
          MyMultiSelectField(
              skills,
              widget.profile.skills,
              "What are your passions?",
              "Skills",
              selectedSkills,
              Icons.sports_tennis),
          MyMultiSelectField(
              languages,
              widget.profile.languages,
              "What languages do you speak?",
              "Languages",
              selectedLanguages,
              Icons.abc),
        ],
      ),

      /*Scaffold(

                    }).toList(),
                  ),
                ],
              ),
              Row(
                children: [

                ),
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      initialValue: widget.profile.languages,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text("Languages"),
                      title: const Text("Languages"),
                      buttonIcon: const Icon(
                        Icons.flag,
                      ),
                      searchIcon: const Icon(
                        Icons.search,
                      ),
                      items:
                          languages.map((s) => MultiSelectItem(s, s)).toList(),
                      onConfirm: (values) {
                        selectedLanguages =
                            values.map((e) => e.toString()).toList();
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            selectedLanguages.remove(value.toString());
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      initialValue: widget.profile.skills,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text("Skills"),
                      title: const Text("Skills"),
                      buttonIcon: const Icon(
                        Icons.sports_tennis,
                      ),
                      searchIcon: const Icon(
                        Icons.search,
                      ),
                      items: skills.map((s) => MultiSelectItem(s, s)).toList(),
                      onConfirm: (values) {
                        selectedSkills =
                            values.map((e) => e.toString()).toList();
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            selectedSkills.remove(value.toString());
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),*/
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
