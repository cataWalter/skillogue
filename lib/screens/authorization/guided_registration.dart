import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/misc_functions.dart';
import 'package:skillogue/widgets/my_multi_select_field.dart';
import 'package:skillogue/widgets/my_text_field.dart';
import 'package:skillogue/widgets/my_uni_select_field.dart';

import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/data.dart';

class GuidedRegistration extends StatefulWidget {
  final String email;

  const GuidedRegistration(this.email, {super.key});

  @override
  State<GuidedRegistration> createState() => _GuidedRegistrationState();
}

class _GuidedRegistrationState extends State<GuidedRegistration> {
  final controllerFullName = TextEditingController();
  final controllerAge = TextEditingController();

  List<String> selectedLanguages = [];
  List<String> selectedSkills = [];
  String selectedGender = "";
  String selectedCity = "";
  String selectedCountry = "";

  void nextScreen(registeredProfile) async {
    profile = registeredProfile;
    profileSearch = ProfileSearch();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(
          [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Center(
          child: Text(
            "Let's make this profile look good!",
            style: GoogleFonts.bebasNeue(
              fontSize: 28,
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
          var parameters = {};
          if (selectedCountry.isNotEmpty &&
              selectedGender.isNotEmpty &&
              selectedCity.isNotEmpty &&
              controllerFullName.text.isNotEmpty &&
              selectedLanguages.isNotEmpty &&
              controllerAge.text.isNotEmpty &&
              int.parse(controllerAge.text) >= 18 &&
              int.parse(controllerAge.text) <= 99) {
            parameters.addAll({'country': selectedCountry});
            parameters.addAll({'gender': selectedGender});
            parameters.addAll({'city': selectedCity});
            parameters.addAll({'name': controllerFullName.text});
            parameters.addAll({'languages': selectedLanguages});
            parameters.addAll({'skills': selectedSkills});
            parameters.addAll({'age': int.parse(controllerAge.text)});
            parameters.addAll({'color': getRandomDarkColor().value});
            await supabase
                .from('profile')
                .update(parameters)
                .eq('email', widget.email);
            Profile registeredProfile = await findProfileByEmail(widget.email);
            nextScreen(registeredProfile);
          } else {
            showSnackBar(
                "😡 Don't make me angry! Fill that profile! 😡", context);
          }
        },
        icon: const Icon(Icons.save),
        label: const Text("Save"),
      ),
      body: listViewCreator(
        [
          MyTextField(
            controllerFullName,
            "Full Name",
            "Full Name",
            TextInputType.text,
          ),
          MyTextField(
            controllerAge,
            "Age",
            "Age",
            TextInputType.number,
          ),
          MyUniSelectField(
            cities,
            "Cities",
            "What's your city?",
            "City",
            selectedCity,
            Icons.location_city,
          ),
          MyUniSelectField(
            countries,
            "Countries",
            "What's your country?",
            "Country",
            selectedCountry,
            Icons.flag,
          ),
          MyUniSelectField(
            genders,
            "Genders",
            "What's your gender?",
            "Gender",
            selectedGender,
            Icons.female,
          ),
          MyMultiSelectField(
            skills,
            selectedSkills,
            "What are your passions?",
            "Passions",
            selectedSkills,
            Icons.sports_tennis,
          ),
          MyMultiSelectField(
            languages,
            selectedLanguages,
            "What languages do you speak?",
            "Languages",
            selectedLanguages,
            Icons.abc,
          ),
        ],
      ),
    );
  }
}
