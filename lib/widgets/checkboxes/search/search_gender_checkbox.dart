import 'package:flutter/material.dart';
import 'package:skillogue/entities/search.dart';

class SearchGenderCheckbox extends StatefulWidget {
  String text;
  Search curSearch;


  SearchGenderCheckbox(this.text, this.curSearch, {super.key});

  @override
  State<SearchGenderCheckbox> createState() => _SearchGenderCheckboxState();
}

class _SearchGenderCheckboxState extends State<SearchGenderCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curSearch.genders.contains(widget.text),
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curSearch.addGender(widget.text);
            } else {
              widget.curSearch.delGender(widget.text);
            }
          });
        });
  }
}
