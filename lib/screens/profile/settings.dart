import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/constants.dart';

class Settings extends StatefulWidget {
  final Profile profile;
  final List<Conversation> conversations;
  final ProfileSearch search;

  const Settings(this.profile, this.conversations, this.search, {super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final controllerFullName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerCity = TextEditingController();
  String dropdownCountryValue = 'Country-less Wanderer';
  String dropdownGenderValue = 'Other';
  List<String> selectedLanguages = [];
  List<String> selectedSkills = [];

  bool changedCountry = false;
  bool changedGender = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      appName,
                      style: GoogleFonts.bebasNeue(
                          fontSize: 28, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 40,
                      child: Image.asset(
                        'assets/images/logo2.png',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
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
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
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
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: widget.profile.fullName.isNotEmpty
                            ? widget.profile.fullName
                            : "Full Name",
                        labelStyle: textFieldStyleWithOpacity,
                        labelText: 'Full Name',
                        hintStyle: textFieldStyleWithOpacity,
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                    ),
                  ),
                ),
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
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: widget.profile.age.toString().isNotEmpty &&
                                widget.profile.age <= 99
                            ? widget.profile.age.toString()
                            : "Age",
                        labelText: 'Age',
                        hintStyle: textFieldStyleWithOpacity,
                        labelStyle: textFieldStyleWithOpacity,
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                    ),
                  ),
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
                        hintText: widget.profile.city.isNotEmpty
                            ? widget.profile.city
                            : "City" +
                                "(Please use the English Spelling of your city)",
                        labelText: 'City',
                        hintStyle: textFieldStyleWithOpacity,
                        labelStyle: textFieldStyleWithOpacity,
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Country:",
                      style: TextStyle(
                          color: Colors.white.withOpacity(STANDARD_OPACITY)),
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
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.blue[900],
                      underline: Container(
                        height: 3,
                        color: Colors.blue,
                      ),
                      onChanged: (String? value) {
                        changedCountry = true;
                        setState(() {
                          dropdownCountryValue = value!;
                        });
                      },
                      items: countries
                          .map<DropdownMenuItem<String>>((String value) {
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
                    Text(
                      "Gender:",
                      style: TextStyle(
                          color: Colors.white.withOpacity(STANDARD_OPACITY)),
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
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.blue[900],
                      underline: Container(
                        height: 3,
                        color: Colors.blue,
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
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
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
                        items: languages
                            .map((s) => MultiSelectItem(s, s))
                            .toList(),
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
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
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
                        items:
                            skills.map((s) => MultiSelectItem(s, s)).toList(),
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
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        updateLocalProfileSettings();
                        updateDatabaseProfileSettings();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(widget.profile,
                                  widget.conversations, widget.search),
                            ));
                      },
                      child: Container(
                        height: 80,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            'Save',
                            style: GoogleFonts.bebasNeue(
                                fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
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
      widget.profile.fullName = controllerFullName.text;
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
    Profile loggedProfile = await queryByUsername(widget.profile.username);
    var oldProfile = ParseObject('Profile')..objectId = loggedProfile.objectId;
    if (changedCountry) {
      oldProfile.set('country', dropdownCountryValue);
    }
    if (changedGender) {
      oldProfile.set('gender', dropdownGenderValue);
    }
    if (controllerFullName.text.isNotEmpty) {
      oldProfile.set('fullName', controllerFullName.text);
    }
    if (selectedLanguages.isNotEmpty) {
      oldProfile.set('languages', selectedLanguages);
    }
    if (selectedSkills.isNotEmpty) {
      oldProfile.set('skills', selectedSkills);
    }

    if (controllerAge.text.isNotEmpty) {
      int newAge = int.parse(controllerAge.text);
      if (newAge >= 18 && newAge <= 99) {
        oldProfile.set('age', newAge);
      }
    }
    if (controllerCity.text.isNotEmpty) {
      oldProfile.set('city', capitalizeFirstLetterString(controllerCity.text));
    }
    await oldProfile.save();
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
