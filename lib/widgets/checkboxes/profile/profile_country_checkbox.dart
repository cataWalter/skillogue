import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/utils/constants.dart';

class ProfileCountryCheckbox extends StatefulWidget {
  String text;
  Profile curProfile;

  ProfileCountryCheckbox(this.text, this.curProfile, {super.key});

  @override
  State<ProfileCountryCheckbox> createState() => _ProfileCountryCheckboxState();
}

class _ProfileCountryCheckboxState extends State<ProfileCountryCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curProfile.country == widget.text,
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curProfile.addCountry(widget.text);
            } else {
              widget.curProfile.delCountry(widget.text);
            }
          });
        });
  }
}
