import 'package:flutter/material.dart';
import 'package:skillogue/entities/search.dart';

class SearchSkillCheckbox extends StatefulWidget {
  String text;
  Search curSearch;


  SearchSkillCheckbox(this.text, this.curSearch, {super.key});

  @override
  State<SearchSkillCheckbox> createState() => _SearchSkillCheckboxState();
}

class _SearchSkillCheckboxState extends State<SearchSkillCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curSearch.skills.contains(widget.text),
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curSearch.addSkill(widget.text);
            } else {
              widget.curSearch.delSkill(widget.text);
            }
          });
        });
  }
}
