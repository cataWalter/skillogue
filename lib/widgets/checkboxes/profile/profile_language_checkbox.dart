import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search_entity.dart';

class ProfileLanguageCheckbox extends StatefulWidget {
  String text;
  Profile curProfile;


  ProfileLanguageCheckbox(this.text, this.curProfile, {super.key});

  @override
  State<ProfileLanguageCheckbox> createState() => _ProfileLanguageCheckboxState();
}

class _ProfileLanguageCheckboxState extends State<ProfileLanguageCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curProfile.languages.contains(widget.text),
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curProfile.addLanguage(widget.text);
            } else {
              widget.curProfile.delLanguage(widget.text);
            }
          });
        });
  }
}
