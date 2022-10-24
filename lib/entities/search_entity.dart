import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/entities/search_result.dart';

class Search {
  String? username;
  List<String> skills = [];
  List<String> countries = [];
  List<String> languages = [];
  List<String> genders = [];
  String? city;
  String? region;
  int? minAge;
  int? maxAge;
  int? minTimezone;
  int? maxTimezone;

  Search();

  @override
  String toString() {
    return 'Search{username: $username, skills: $skills, countries: $countries, languages: $languages, '
        'city: $city, region: $region, minAge: $minAge, maxAge: $maxAge, minTimezone: $minTimezone, maxTimezone: $maxTimezone}';
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

  void addCountry(String text) {
    if (!countries.contains(text)) {
      countries.add(text);
    }
  }

  void delCountry(String text) {
    if (countries.contains(text)) {
      countries.remove(text);
    }
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
    if (!genders.contains(text)) {
      genders.add(text);
    }
  }

  void delGender(String text) {
    if (genders.contains(text)) {
      genders.remove(text);
    }
  }
}

Future<List<SearchResult>> findUsers(String username) async {
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
  return filterUser(username, searchResults(results));
}

Future<List<SearchResult>> filterUser(
    String username, List<SearchResult> s) async {
  for (SearchResult x in s) {
    if (username == x.username) {
      s.remove(x);
    }
  }
  List<String> s1 = getContactedSender(username) as List<String>;
  return s;
}

List<SearchResult> searchResults(List<ParseObject> results) {
  List<SearchResult> newResults = <SearchResult>[];
  for (var t in results) {
    newResults.add(searchResultFromJson(t));
  }
  return newResults;
}

SearchResult searchResultFromJson(dynamic t) {
  return SearchResult(
    t['username'] as String,
    t['fullName'] as String,
    (t['skills'] as List).map((e) => e as String).toList(),
    t['country'] as String,
    t['gender'] as String,
    (t['languages'] as List).map((e) => e as String).toList(),
    t['city'] as String,
    t['region'] as String,
    t['age'] as int,
    t['updatedAt'] as DateTime,
  );
}

Future<List<String>> getContactedSender(String username) async {
  List<ParseObject> results = <ParseObject>[];
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('Contacted'));
  parseQuery.whereContains('sender', username);
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  } else {
    results = [];
  }
  return listContacted(results);
}

List<String> listContacted(List<ParseObject> results) {
  List<String> newResults = <String>[];
  for (var t in results) {
    newResults.add(t['receiver']);
  }
  return newResults;
}
