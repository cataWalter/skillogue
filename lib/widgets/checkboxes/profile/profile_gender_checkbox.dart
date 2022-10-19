import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';

class ProfileGenderCheckbox extends StatefulWidget {
  String text;
  Profile curProfile;


  ProfileGenderCheckbox(this.text, this.curProfile, {super.key});

  @override
  State<ProfileGenderCheckbox> createState() => _ProfileGenderCheckboxState();
}

class _ProfileGenderCheckboxState extends State<ProfileGenderCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curProfile.gender == widget.text,
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curProfile.addGender(widget.text);
            } else {
              widget.curProfile.delGender(widget.text);
            }
          });
        });
  }
}
