import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:skillogue/screens/home_screen.dart';
import 'package:skillogue/utils/backend/profile_backend.dart';

import '../../main.dart';
import '../../utils/colors.dart';
import '../../widgets/appbar.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late bool isDark = themeManager.isDarkNow();
  late Color selectedColor = profile.color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: ThisAppBar(profile.name, false),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        children: <Widget>[
          ListTile(
            title: const Text('Set your color'),
            subtitle: Text(ColorTools.nameThatColor(selectedColor)),
            trailing: ColorIndicator(
              width: 44,
              height: 44,
              borderRadius: 4,
              color: selectedColor,
              onSelectFocus: false,
              onSelect: () async {
                // Store current color before we open the dialog.
                final Color colorBeforeDialog = selectedColor;
                // Wait for the picker to close, if dialog was dismissed,
                // then restore the color we had before it was opened.
                if (!(await colorPickerDialog())) {
                  setState(() {
                    selectedColor = colorBeforeDialog;
                  });
                }
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Turn ON for dark mode'),
            subtitle: const Text('Turn OFF for light mode'),
            value: isDark,
            onChanged: (bool value) {
              setState(() {
                isDark = value;
                (isDark
                    ? themeManager.toggleDark()
                    : themeManager.toggleLight());
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
              builder: (context) => Home(
                conversations,
              ),
            ),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text("Save"),
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
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
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
