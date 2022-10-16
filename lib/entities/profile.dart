import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Profile {
  String username;
  String? fullName;
  String? country;
  String? city;
  String? region;
  int? sex;
  int? age;
  int? timezone;
  int? points;
  DateTime? lastLogin;

  List<String> skills = [];

  Profile(this.username, this.fullName, this.country, this.city, this.region,
      this.sex, this.age, this.timezone, this.points, this.lastLogin);

  @override
  String toString() {
    return 'Profile{username: $username, fullName: $fullName, country: $country, city: $city, region: $region, sex: $sex, age: $age, timezone: $timezone, points: $points, lastLogin: $lastLogin}';
  }

  List<String> toKeys() {
    return [
      "username",
      "fullName",
      "country",
      "city",
      "region",
      "sex",
      "age",
      "timezone",
      "points",
      "lastLogin"
    ];
  }

  void newProfileUpload() async {
    var myTable = ParseObject("Profile");
    myTable.set("username", username);
    myTable.set("fullName", fullName);
    myTable.set("country", country);
    myTable.set("city", city);
    myTable.set("region", region);
    myTable.set("sex", sex);
    myTable.set("age", age);
    myTable.set("timezone", timezone);
    myTable.set("points", points);
    myTable.set("lastLogin", lastLogin);
    await myTable.save();
  }

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
    t['username'] as String,
    t['fullName'] as String,
    t['country'] as String,
    t['city'] as String,
    t['region'] as String,
    t['sex'] as int,
    t['age'] as int,
    t['timezone'] as int,
    t['points'] as int,
    t['lastLogin'] as DateTime,
  );
}
