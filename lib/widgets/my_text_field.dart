import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType textInputType;
  final IconData iconData;

  const MyTextField(
      this.controller, this.hint, this.textInputType, this.iconData,
      {super.key});

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
          hintText: hint,
          hintStyle:
              TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
          filled: true,
          suffixIcon:
              Icon(iconData, color: const Color.fromRGBO(129, 129, 129, 1)),
        ),
      ),
    );
  }
}
