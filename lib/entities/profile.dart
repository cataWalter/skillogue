import 'dart:core';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/message.dart';

class Profile {
  String objectId;
  String username;
  String fullName;
  String country;
  String city;
  String gender;
  int age;
  DateTime? lastLogin;
  List<String> skills = [];
  List<String> languages = [];
  List<Message> messages = [];
  bool logged = true;

  Profile(this.objectId, this.username, this.fullName, this.country, this.city,
      this.gender, this.age, this.skills, this.languages);

  void addGender(String text) {
    gender = text;
  }

  void delGender(String text) {
    gender = "Genderless Wanderer";
  }

  bool isEmptyProfile() {
    return fullName.isEmpty ||
        country.isEmpty ||
        city.isEmpty ||
        gender.isEmpty ||
        age.toString().isEmpty ||
        skills.isEmpty ||
        languages.isEmpty;
  }
}

Future<Profile> queryByUsername(String username) async {
  List<ParseObject> results = <ParseObject>[];
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('Profile'));
  parseQuery.whereContains('username', username);
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  } else {
    results = [];
  }
  return profilesFromResults(results)[0];
}

Future<List<Profile>> queryAllProfiles() async {
  List<ParseObject> results = <ParseObject>[];
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('Profile'));
  //parseQuery.whereContains('att1', 'Walter');
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  } else {
    results = [];
  }
  return profilesFromResults(results);
}

List<Profile> profilesFromResults(List<ParseObject> results) {
  List<Profile> newResults = <Profile>[];
  for (var t in results) {
    newResults.add(profileFromJson(t));
  }
  return newResults;
}

Profile profileFromJson(dynamic t) {
  List<String> skills = [];
  for (var x in t['skills']) {
    skills.add(x);
  }
  List<String> languages = [];
  for (var x in t['languages']) {
    languages.add(x);
  }
  int newAge = t['age'] as int;
  if (newAge < 18 || newAge > 99) {
    newAge = 100;
  }
  return Profile(
    t['objectId'] as String,
    t['username'] as String,
    t['fullName'] as String,
    t['country'] as String,
    t['city'] as String,
    t['gender'] as String,
    newAge,
    skills,
    languages,
  );
}

void newProfileUpload(String username) async {
  final profile = ParseObject('Profile')
    ..set('username', username)
    ..set('fullName', "")
    ..set('country', "")
    ..set('city', "")
    ..set('gender', "")
    ..set('age', 0)
    ..set('lastLogin', DateTime.now())
    ..set('skills', [])
    ..set('languages', []);
  await profile.save();
}



String initials(String fullName) {
  if (fullName.length < 3) {
    return "";
  }
  return fullName[0].toUpperCase() +
      fullName[1].toUpperCase() +
      fullName[2].toUpperCase();
}
