import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/constants.dart';

import '../../utils/backend/profile_backend.dart';

class GuidedRegistration extends StatefulWidget {
  final String email;

  const GuidedRegistration(this.email, {super.key});

  @override
  _GuidedRegistrationState createState() => _GuidedRegistrationState();
}

class _GuidedRegistrationState extends State<GuidedRegistration> {
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
                      widget.email,
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
                        hintText: "Full Name",
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
                        hintText: "Age",
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
                        hintText:
                            "City (Please use the English Spelling of your city)",
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
                          color: Colors.white.withOpacity(standardOpacity)),
                    ),
                    const SizedBox(
                      width: 27,
                    ),
                    DropdownButton<String>(
                      value: dropdownCountryValue,
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
                          color: Colors.white.withOpacity(standardOpacity)),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    DropdownButton<String>(
                      value: dropdownGenderValue,
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
                        initialValue: const [],
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
                        initialValue: const [],
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
                const SizedBox(
                  height: 40,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.save),
                  onPressed: () async {
                    var parameters = {};
                    if (changedCountry &&
                        changedGender &&
                        controllerCity.text.isNotEmpty &&
                        controllerFullName.text.isNotEmpty &&
                        selectedLanguages.isNotEmpty &&
                        controllerAge.text.isNotEmpty &&
                        int.parse(controllerAge.text) >= 18 &&
                        int.parse(controllerAge.text) <= 99) {
                      parameters.addAll({'country': dropdownCountryValue});
                      parameters.addAll({'gender': dropdownGenderValue});
                      parameters.addAll({
                        'city': capitalizeFirstLetterString(controllerCity.text)
                      });
                      parameters.addAll({'name': controllerFullName.text});
                      parameters.addAll({'languages': selectedLanguages});
                      parameters.addAll({'skills': selectedSkills});
                      parameters.addAll({'age': int.parse(controllerAge.text)});
                      await supabase
                          .from('profile')
                          .update(parameters)
                          .eq('email', widget.email);
                      Profile registeredProfile =
                          await findProfileByEmail(widget.email);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            [],
                            registeredProfile,
                            ProfileSearch(),
                          ),
                        ),
                      );
                    } else {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    );
  }

  String capitalizeFirstLetterString(String s) {
    return "${s[0].toUpperCase()}${s.substring(1).toLowerCase()}";
  }
}
