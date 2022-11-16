import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/conversation.dart';
import 'package:skillogue/entities/profile_search_result.dart';

class ProfileSearch {
  List<String> skills = [];
  List<String> countries = [];
  List<String> languages = [];
  List<String> genders = [];
  String? city;
  int? minAge;
  int? maxAge;
}

Future<List<ProfileSearchResult>> findUsers(String searcher,
    ProfileSearch curSearch, List<Conversation> conversations) async {
  List<ParseObject> results = <ParseObject>[];
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('Profile'));
  parseQuery.whereNotEqualTo('username', searcher);

  if (curSearch.skills.isNotEmpty) {
    parseQuery.whereArrayContainsAll('skills', curSearch.skills);
  }
  if (curSearch.languages.isNotEmpty) {
    parseQuery.whereArrayContainsAll('languages', curSearch.languages);
  }
  if (curSearch.countries.isNotEmpty) {
    parseQuery.whereArrayContainsAll('countries', curSearch.countries);
  }
  if (curSearch.genders.isNotEmpty) {
    parseQuery.whereArrayContainsAll('genders', curSearch.genders);
  }

  if (curSearch.city != "") {
    parseQuery.whereEqualTo('city', curSearch.city);
  }
  parseQuery.whereGreaterThanOrEqualsTo('age', curSearch.minAge);
  parseQuery.whereLessThanOrEqualTo('age', curSearch.maxAge);

  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  } else {
    results = [];
  }
  return filterUser(searcher, searchResults(results), conversations);
}

Future<List<ProfileSearchResult>> filterUser(
    String username,
    List<ProfileSearchResult> searchResults,
    List<Conversation> conversations) async {
  List<ProfileSearchResult> s = [];
  for (ProfileSearchResult searchResult in searchResults) {
    if (!toFilter(searchResult, conversations, username)) {
      s.add(searchResult);
    }
  }
  return s;
}

bool toFilter(
    ProfileSearchResult s, List<Conversation> conversations, String username) {
  if (s.username == username) {
    return true;
  }
  for (Conversation c in conversations) {
    if (c.username == s.username) {
      return true;
    }
  }
  return false;
}

List<ProfileSearchResult> searchResults(List<ParseObject> results) {
  List<ProfileSearchResult> newResults = <ProfileSearchResult>[];
  for (var t in results) {
    newResults.add(searchResultFromJson(t));
  }
  return newResults;
}

ProfileSearchResult searchResultFromJson(dynamic t) {
  return ProfileSearchResult(
    t['username'] as String,
    t['fullName'] as String,
    (t['skills'] as List).map((e) => e as String).toList(),
    t['country'] as String,
    t['gender'] as String,
    (t['languages'] as List).map((e) => e as String).toList(),
    t['city'] as String,
    t['age'] as int,
    t['updatedAt'] as DateTime,
  );
}
