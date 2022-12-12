import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/screens/home_screen.dart';

import '../../widgets/appbar.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/data.dart';
import '../../utils/misc_functions.dart';

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
  final controllerCity = TextEditingController();
  String dropdownCountryValue = 'Other';
  String dropdownGenderValue = 'Other';
  List<String> selectedLanguages = [];
  List<String> selectedSkills = [];

  bool changedCountry = false;
  bool changedGender = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
      body: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextField(
                    controller: controllerFullName,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: widget.profile.name.isNotEmpty
                          ? widget.profile.name
                          : "Full Name",
                      labelText: 'Full Name',
                      filled: true,
                    ),
                  ),
                ),
              ),
              addVerticalSpace(15),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextField(
                    controller: controllerAge,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: widget.profile.age.toString().isNotEmpty &&
                              widget.profile.age <= 99
                          ? widget.profile.age.toString()
                          : "Age",
                      labelText: 'Age',
                      filled: true,
                    ),
                  ),
                ),
              ),
              addVerticalSpace(15),
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
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      hintText: widget.profile.city.isNotEmpty
                          ? widget.profile.city
                          : "City (Please use the English Spelling of your city)",
                      labelText: 'City',
                      filled: true,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Country:",
                  ),
                  const SizedBox(
                    width: 27,
                  ),
                  DropdownButton<String>(
                    value: widget.profile.country.isNotEmpty
                        ? widget.profile.country
                        : dropdownCountryValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 3,
                    ),
                    onChanged: (String? value) {
                      changedCountry = true;
                      setState(() {
                        dropdownCountryValue = value!;
                      });
                    },
                    items:
                        countries.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Gender:",
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  DropdownButton<String>(
                    value: widget.profile.gender.isNotEmpty
                        ? widget.profile.gender
                        : dropdownGenderValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 3,
                    ),
                    onChanged: (String? value) {
                      changedGender = true;
                      setState(() {
                        dropdownGenderValue = value!;
                      });
                    },
                    items:
                        genders.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
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
    if (changedCountry) {
      widget.profile.country = dropdownCountryValue;
    }
    if (changedGender) {
      widget.profile.gender = dropdownGenderValue;
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
    if (controllerCity.text.isNotEmpty) {
      widget.profile.city = capitalizeFirstLetterString(controllerCity.text);
    }
  }

  void updateDatabaseProfileSettings() async {
    var parameters = {};
    if (changedCountry) {
      parameters.addAll({'country': dropdownCountryValue});
    }
    if (changedGender) {
      parameters.addAll({'gender': dropdownGenderValue});
    }
    if (controllerCity.text.isNotEmpty) {
      parameters
          .addAll({'city': capitalizeFirstLetterString(controllerCity.text)});
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
