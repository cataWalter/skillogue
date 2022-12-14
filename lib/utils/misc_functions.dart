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

SizedBox addVerticalSpace(int height) {
  return SizedBox(
    height: height.toDouble(),
  );
}

SizedBox addHorizontalSpace(int width) {
  return SizedBox(
    width: width.toDouble(),
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

void showSnackBar(String message, context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}

ListView listViewCreator(List<Widget> widgets) {
  List<Widget> res = [];
  for (Widget x in widgets) {
    res.add(ListTile(
      title: x,
    ));
  }
  return ListView(
    children: res,
  );
}
