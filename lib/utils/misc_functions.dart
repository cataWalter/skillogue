import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'localization.dart';

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

List<Widget> profileChippies(List<String> toChip, double size) {
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
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
  ));
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

popScreen(context) {
  Navigator.of(context).pop();
}

int getElementIndex(el, myList) {
  for (int i = 0; i < myList.length; i++) {
    if (myList[i] == el) {
      return i;
    }
  }
  return -1;
}

void getBlurDialog(context, title, message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(
                AppLocale.ok.getString(context),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    },
  );
}

void getBlurDialogImage(context, title, image, exit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          title: Text(title),
          content: SizedBox(
            child: Image.asset(image),
          ),
          actions: [
            TextButton(
              child: Text(
                exit,
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    },
  );
}

Container limitMaxWidth(Widget x, int minWidth, int maxWidth) {
  return Container(
    constraints: BoxConstraints(
        minWidth: minWidth.toDouble(), maxWidth: maxWidth.toDouble()),
    child: x,
  );
}
AutoSizeText getOverflowReplacement(String t, bool normal) {
  if (normal) {
    return AutoSizeText(
      t,
      overflow: TextOverflow.ellipsis,
      minFontSize: 14,
      maxLines: 1,
    );
  } else {
    return AutoSizeText(
      t,
      style: const TextStyle(fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
      minFontSize: 14,
      maxLines: 1,
    );
  }
}
/*
context.getString("string")
context.getString("string"),
context.getString("string");
 */
