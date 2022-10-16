import 'package:flutter/material.dart';
import 'package:skillogue/entities/search_entity.dart';

class MyCheckBox extends StatefulWidget {
  String text;
  Search curSearch;


  MyCheckBox(this.text, this.curSearch, {super.key});

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
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
