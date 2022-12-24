import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:skillogue/utils/constants.dart';

import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/localization.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late bool isDark = themeManager.isDarkNow();
  late Color selectedColor = profile.color;
  final _myBox = Hive.box(localDatabase);

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
                    profile.name,
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
      body: ListView(
        padding: tabletMode ? tabletEdgeInsets : const EdgeInsets.fromLTRB(8, 0, 8, 0),
        children: <Widget>[
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
          SwitchListTile(
            title: Text(AppLocale.darkMode.getString(context)),
            subtitle: Text(AppLocale.lightMode.getString(context)),
            value: isDark,
            onChanged: (bool value) {
              setState(() {
                _myBox.put(darkModeKey, value);
                isDark = value;
                (isDark
                    ? themeManager.toggleDark()
                    : themeManager.toggleLight());
              });
            },
          ),
          SwitchListTile(
            title:
                Text(AppLocale.artificialIntelligenceEnable.getString(context)),
            subtitle: Text(
                AppLocale.artificialIntelligenceDisabled.getString(context)),
            value: artificialIntelligenceEnabled,
            onChanged: (bool value) {
              setState(() {
                _myBox.put(artificialIntelligenceKey, value);
                artificialIntelligenceEnabled = value;
              });
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          updateLocalProfileSettings();
          updateDatabaseProfileSettings();
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
      profile.color = selectedColor;
    });
  }

  void updateDatabaseProfileSettings() async {
    var parameters = {};
    parameters.addAll({'color': selectedColor.value});
    updateProfile(profile.email, parameters);
  }
}
