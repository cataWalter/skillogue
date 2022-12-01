import 'package:flutter/cupertino.dart';

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
