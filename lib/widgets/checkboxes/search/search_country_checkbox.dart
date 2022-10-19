import 'package:flutter/material.dart';
import 'package:skillogue/entities/search_entity.dart';

class SearchCountryCheckbox extends StatefulWidget {
  String text;
  Search curSearch;


  SearchCountryCheckbox(this.text, this.curSearch, {super.key});

  @override
  State<SearchCountryCheckbox> createState() => _SearchCountryCheckboxState();
}

class _SearchCountryCheckboxState extends State<SearchCountryCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.text),
        value: widget.curSearch.countries.contains(widget.text),
        onChanged: (value) {
          setState(() {
            this.value = value!;
            if (this.value == true) {
              widget.curSearch.addCountry(widget.text);
            } else {
              widget.curSearch.delCountry(widget.text);
            }
          });
        });
  }
}
