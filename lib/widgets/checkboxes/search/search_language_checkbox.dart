import 'package:flutter/material.dart';
import 'package:skillogue/entities/search_entity.dart';

class SearchLanguageCheckbox extends StatefulWidget {
  String text;
  Search curSearch;


  SearchLanguageCheckbox(this.text, this.curSearch, {super.key});

  @override
  State<SearchLanguageCheckbox> createState() => _SearchLanguageCheckboxState();
}

class _SearchLanguageCheckboxState extends State<SearchLanguageCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curSearch.languages.contains(widget.text),
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curSearch.addLanguage(widget.text);
            } else {
              widget.curSearch.delLanguage(widget.text);
            }
          });
        });
  }
}
