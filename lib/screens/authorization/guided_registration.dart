import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/misc_functions.dart';
import 'package:skillogue/widgets/mono_dropdown.dart';
import 'package:skillogue/widgets/multi_dropdown.dart';
import 'package:skillogue/widgets/my_text_field.dart';

import '../../main.dart';
import '../../utils/backend/authorization_backend.dart';
import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/constants.dart';
import '../../utils/data.dart';
import '../../utils/localization.dart';

class GuidedRegistration extends StatefulWidget {
  final String email;
  final String password;

  const GuidedRegistration(this.email, this.password, {super.key});

  @override
  State<GuidedRegistration> createState() => _GuidedRegistrationState();
}

class _GuidedRegistrationState extends State<GuidedRegistration> {
  final controllerFullName = TextEditingController();
  final controllerAge = TextEditingController();

  List<String> selectedLanguages = [];
  List<String> selectedSkills = [];
  String selectedGender = "";
  String selectedCountry = "";
  String selectedCity = "";

  void nextScreen(registeredProfile) async {
    profile = registeredProfile;
    activeProfileSearch = ProfileSearch();
    //activeEventSearch = EventSearch();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          const [],
          0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Center(
          child: Text(
            AppLocale.lookGoodProfile.getString(context),
            style: GoogleFonts.bebasNeue(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedCountry.isNotEmpty &&
              selectedGender.isNotEmpty &&
              selectedCity.isNotEmpty &&
              controllerFullName.text.isNotEmpty &&
              selectedLanguages.isNotEmpty &&
              controllerAge.text.isNotEmpty &&
              int.parse(controllerAge.text) >= 18 &&
              int.parse(controllerAge.text) <= 99) {
            await registration(widget.email, widget.password);
            databaseInsert(
              'profile',
              {
                'email': widget.email,
                'country': selectedCountry,
                'gender': selectedGender,
                'city': selectedCity,
                'name': controllerFullName.text,
                'languages': selectedLanguages,
                'skills': selectedSkills,
                'age': int.parse(controllerAge.text),
                'color': getRandomDarkColor().value,
                'points': 0
              },
            );
            Profile registeredProfile = await findProfileByEmail(widget.email);
            nextScreen(registeredProfile);
          } else {
            //showSnackBar(context.getString("fill profile"), context);
          }
        },
        icon: const Icon(Icons.save),
        label: const Text("Save"),
      ),
      body: Padding(
        padding: tabletMode ? tabletEdgeInsets : phoneEdgeInsets,
        child: listViewCreator(
          [
            MyTextField(
                controllerFullName,
                AppLocale.personalName.getString(context),
                TextInputType.text,
                Icons.person),
            MyTextField(controllerAge, AppLocale.age.getString(context),
                TextInputType.number, Icons.numbers),
            MonoDropdown(
              cities,
              AppLocale.cities.getString(context),
              selectedCity.isNotEmpty
                  ? selectedCity
                  : AppLocale.yourCity.getString(context),
              Icons.location_city,
              (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
            MonoDropdown(
              countries,
              AppLocale.countries.getString(context),
              selectedCountry.isNotEmpty
                  ? selectedCountry
                  : AppLocale.yourCountry.getString(context),
              Icons.flag,
              (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            MonoDropdown(
              genders,
              AppLocale.genders.getString(context),
              selectedGender.isNotEmpty
                  ? selectedGender
                  : AppLocale.yourGender.getString(context),
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
}
