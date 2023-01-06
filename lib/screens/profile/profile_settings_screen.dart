import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/screens/messages/single_conversation_screen.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/utils/responsive_layout.dart';

import '../../entities/profile_entity.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/data.dart';
import '../../utils/localization.dart';
import '../../widgets/mono_dropdown.dart';
import '../../widgets/multi_dropdown.dart';
import '../../widgets/my_text_field.dart';

class ProfileSettings extends StatefulWidget {
  final Profile profile;

  const ProfileSettings(this.profile, {super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late bool isDark = themeManager.isDarkNow();
  late Color selectedColor = chatColor;
  final _myBox = Hive.box(localDatabase);
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(
                width: 100.0,
                height: 40.0,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.grey[800],
                  elevation: 0,
                  onPressed: () {
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
                  label: Text(AppLocale.save.getString(context)),
                ),
              ),
              /*
              Text(
                profile.name,
                style: GoogleFonts.bebasNeue(
                    fontSize: 24,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              )*/
            ],
          ),
        ),
      ),
      body: ResponsiveLayout(
        mobileBody: ListView(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          children: profileSettingsList(),
        ),
        tabletBody: ListView(
          padding: tabletEdgeInsets,
          children: profileSettingsList(),
        ),
        desktopBody: ListView(
          padding: desktopEdgeInsets,
          children: profileSettingsList(),
        ),
      ),
    );
  }

  profileSettingsList() {
    return <Widget>[
      divider("App Settings"),
      SwitchListTile(
        title: Text(AppLocale.darkMode.getString(context)),
        subtitle: Text(AppLocale.lightMode.getString(context)),
        value: isDark,
        onChanged: (bool value) {
          setState(() {
            _myBox.put(darkModeKey, value);
            isDark = value;
            (isDark ? themeManager.toggleDark() : themeManager.toggleLight());
          });
        },
      ),
      ListTile(
        title: MonoDropdown(
          widget.profile.languages,
          AppLocale.languages.getString(context),
          AppLocale.localizatorQuestion.getString(context),
          Icons.abc,
          (value) {
            setState(() {
              mapTranslation(value, context);
            });
          },
        ),
      ),
      divider("Profile"),
      ListTile(
        title: MyTextField(
            controllerFullName,
            widget.profile.name.isNotEmpty
                ? widget.profile.name
                : AppLocale.personalName.getString(context),
            TextInputType.text,
            Icons.person),
      ),
      ListTile(
        title: MyTextField(
            controllerAge,
            widget.profile.age.toString().isNotEmpty && widget.profile.age <= 99
                ? widget.profile.age.toString()
                : AppLocale.age.getString(context),
            TextInputType.number,
            Icons.numbers),
      ),
      ListTile(
        title: MonoDropdown(
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
      ),
      ListTile(
        title: MonoDropdown(
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
      ),
      ListTile(
        title: MonoDropdown(
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
      ),
      ListTile(
        title: MultiDropdown(
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
      ),
      ListTile(
        title: MultiDropdown(
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
      ),
      divider("Search"),
      SwitchListTile(
        title: Text(AppLocale.artificialIntelligenceEnable.getString(context)),
        subtitle:
            Text(AppLocale.artificialIntelligenceDisabled.getString(context)),
        value: artificialIntelligenceEnabled,
        onChanged: (bool value) {
          setState(() {
            _myBox.put(artificialIntelligenceKey, value);
            artificialIntelligenceEnabled = value;
          });
        },
      ),
      divider("Chat"),
      ListTile(
        title: Text(AppLocale.setColor.getString(context)),
        subtitle: Text(ColorTools.nameThatColor(selectedColor)),
        trailing: ColorIndicator(
          width: 44,
          height: 44,
          borderRadius: 4,
          color: selectedColor,
          onSelectFocus: false,
          onSelect: () async {
            final Color colorBeforeDialog = selectedColor;
            if (!(await colorPickerDialog())) {
              setState(() {
                selectedColor = colorBeforeDialog;
              });
            }
          },
        ),
      ),
    ];
  }

  Row divider(String text) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Text("    $text    "),
        const Expanded(child: Divider()),
      ],
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: selectedColor,
      onColorChanged: (Color color) => setState(() => selectedColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        AppLocale.selectColor.getString(context),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        AppLocale.selectColorShade.getString(context),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        AppLocale.selectedColorShade.getString(context),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      /*showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),*/
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  void updateLocalProfileSettings() {
    setState(() {
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
      {
        if (chatColor != selectedColor) {
          chatColor = selectedColor;
          _myBox.put(chatColorKey, chatColor.value);
        }
      }
    });
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
