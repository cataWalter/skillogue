import 'package:flutter/material.dart';
import 'package:skillogue/entities/profile.dart';

class ProfileSkillCheckbox extends StatefulWidget {
  String text;
  Profile curProfile;

  ProfileSkillCheckbox(this.text, this.curProfile, {super.key});

  @override
  State<ProfileSkillCheckbox> createState() => _ProfileSkillCheckboxState();
}

class _ProfileSkillCheckboxState extends State<ProfileSkillCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curProfile.skills.contains(widget.text),
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curProfile.addSkill(widget.text);
            } else {
              widget.curProfile.delSkill(widget.text);
            }
          });
        });
  }
}
