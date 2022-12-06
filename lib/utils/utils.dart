import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String initials(String fullName) {
  if (fullName.length < 3) {
    return "";
  }
  return fullName[0].toUpperCase() +
      fullName[1].toUpperCase() +
      fullName[2].toUpperCase();
}

DateTime stringToDatetime(String x) {
  return DateTime.parse(x);
}

SizedBox addVerticalSpace(height) {
  return SizedBox(
    height: height,
  );
}

SizedBox addHorizontalSpace(width) {
  return SizedBox(
    width: width,
  );
}

Future<void> pause() async {
  await Future.delayed(const Duration(seconds: 1));
}

List<Widget> chippies(List<String> toChip, double size) {
  List<Widget> res = [];
  for (String s in toChip) {
    res.add(Chip(
        label: Text(
          s,
          style: TextStyle(fontSize: size),
        )));
  }
  return res;
}