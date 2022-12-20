import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/profile_search.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/colors.dart';
import 'package:skillogue/utils/misc_functions.dart';
import 'package:skillogue/widgets/mono_dropdown.dart';
import 'package:skillogue/widgets/multi_dropdown.dart';
import 'package:skillogue/widgets/my_text_field.dart';

import '../../utils/backend/authorization_backend.dart';
import '../../utils/backend/misc_backend.dart';
import '../../utils/backend/profile_backend.dart';
import '../../utils/data.dart';

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
            await registration(widget.email, widget.password);
            databaseInsert('profile', {'email': widget.email});
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
          MyTextField(controllerFullName, "Full Name", TextInputType.text,
              Icons.person),
          MyTextField(
              controllerAge, "Age", TextInputType.number, Icons.numbers),
          MonoDropdown(
            cities,
            "Cities",
            selectedCity.isNotEmpty
                ? selectedCity
                : "What's your current city?",
            Icons.location_city,
            (value) {
              setState(() {
                selectedCity = value;
              });
            },
          ),
          MonoDropdown(
            countries,
            "Countries",
            selectedCountry.isNotEmpty
                ? selectedCountry
                : "From what country are you from?",
            Icons.flag,
            (value) {
              setState(() {
                selectedCountry = value;
              });
            },
          ),
          MonoDropdown(
            genders,
            "Genders",
            selectedGender.isNotEmpty ? selectedGender : "What's your gender?",
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
            "Passions",
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
}
