import 'dart:core';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Profile {
  String objectId;
  String username;
  String? fullName;
  String? country;
  String? city;
  String? region;
  String? gender;
  int? age;
  int? points;
  DateTime? lastLogin;

  List<String> skills = [];
  List<String> languages = [];

  Profile(this.objectId, this.username, this.fullName, this.country, this.city, this.region,
      this.gender, this.age, this.points);

  void addSkill(String text) {
    if (!skills.contains(text)) {
      skills.add(text);
    }
  }

  void delSkill(String text) {
    if (skills.contains(text)) {
      skills.remove(text);
    }
  }

  void addCountry(String text) {
    country = text;
  }

  void delCountry(String text) {
    country = "Stateless Wanderer";
  }

  void addLanguage(String text) {
    if (!languages.contains(text)) {
      languages.add(text);
    }
  }

  void delLanguage(String text) {
    if (languages.contains(text)) {
      languages.remove(text);
    }
  }

  void addGender(String text) {
    gender = text;
  }

  void delGender(String text) {
    gender = "Genderless Wanderer";
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
  return Profile(
    t['objectId'] as String,
    t['username'] as String,
    t['fullName'] as String,
    t['country'] as String,
    t['city'] as String,
    t['region'] as String,
    t['gender'] as String,
    t['age'] as int,
    t['points'] as int,
  );
}

void newProfileUpload(String username) async {
  /*final book = ParseObject('Book')
    ..set('title', controllerTitle.text.trim())
    ..set('year', int.parse(controllerYear.text.trim()))
    ..set('genre', ParseObject('Genre')..objectId = genre.objectId)
    ..set('publisher',
        (ParseObject('Publisher')..objectId = publisher.objectId).toPointer());*/
  final profile = ParseObject('Profile')
    ..set('username', username)
    ..set('fullName', "")
    ..set('country', "")
    ..set('city', "")
    ..set('region', "")
    ..set('gender', "")
    ..set('age', 0)
    ..set('points', 0);
  await profile.save();
}
