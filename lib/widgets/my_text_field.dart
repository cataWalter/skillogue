import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String label;
  String hint;
  TextInputType textInputType;
  IconData? iconData;

  MyTextField(this.controller, this.label, this.hint, this.textInputType,
      [this.iconData]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(40.0),
          ),
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color.fromRGBO(235, 235, 235, 1),
          labelText: label,
          labelStyle:
              TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
          hintText: hint,
          hintStyle:
              TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
          filled: true,
          suffixIcon: Icon(iconData),
        ),
      ),
    );
  }
}
