import 'package:flutter/material.dart';

import '../utils/misc_functions.dart';

class ProfileSearch {
  List<String> skills = [];
  List<String> countries = [];
  List<String> languages = [];
  List<String> genders = [];
  String city = "";
  int? minAge;
  int? maxAge;

  ProfileSearch();

  void clean() {
    skills = [];
    countries = [];
    languages = [];
    genders = [];
    city = "";
    minAge = null;
    maxAge = null;
  }

  ProfileSearch copy() {
    ProfileSearch res = ProfileSearch();
    res.skills = skills;
    res.countries = countries;
    res.languages = languages;
    res.genders = genders;
    res.city = city;
    res.minAge = minAge;
    res.maxAge = maxAge;
    return res;
  }
}

List<int> findMax(int howMany, List<double> points) {
  List<double> b = [...points];
  b.sort((b, a) => a.compareTo(b));
  double min = b[howMany - 1];
  List<int> res = [];
  for (int i = 0; i < points.length; i++) {
    if (points[i] >= min) res.add(i);
  }
  return res;
}

suggestFeature(
  List<String> mine,
  int howMany,
  List<String> myList,
  List<List<double>> similarityMatrix,
) {
  try {
    List<double> res1 = [];
    double res2;
    for (String s1 in myList) {
      res2 = 0;
      if (!mine.contains(s1)) {
        for (String s2 in mine) {
          res2 += similarityMatrix[getElementIndex(s1, myList)]
              [getElementIndex(s2, myList)];
        }
      }
      res1.add(res2);
    }
    List<int> newSkillIndexes = findMax(howMany, res1);
    List<String> res = [];
    for (int x in newSkillIndexes) {
      res.add(myList[x]);
    }
    return res;
  } catch (e) {
    return [];
  }
}

List<Widget> chippies(
    List<String> skills, List<String> languages, double size) {
  List<Widget> res = [];
  for (String item in skills) {
    res.add(
      Chip(
        backgroundColor: Colors.blue[800],
        label: Text(
          item,
          style: TextStyle(fontSize: size, color: Colors.white),
        ),
      ),
    );
  }
  for (String item in languages) {
    res.add(
      Chip(
        backgroundColor: Colors.green,
        label: Text(
          item,
          style: TextStyle(fontSize: size, color: Colors.white),
        ),
      ),
    );
  }
  return res;
}

class SavedProfileSearch {
  String name;
  ProfileSearch search;

  SavedProfileSearch(this.name, this.search);
}
