import 'dart:collection';

import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../entities/conversation_entity.dart';
import '../../entities/profile_entity.dart';
import '../../entities/profile_search_entity.dart';
import 'misc_backend.dart';

Future<List<Profile>> findUsers(String searcher, ProfileSearch curSearch,
    List<Conversation> conversations, context) async {
  PostgrestFilterBuilder query =
      supabase.from("profile").select().neq("email", searcher);
  if (curSearch.countries.isNotEmpty) {
    query = query.in_("country", curSearch.countries.toList());
  }
  if (curSearch.skills.isNotEmpty) {
    query = query.contains("skills", curSearch.skills);
  }
  if (curSearch.languages.isNotEmpty) {
    query = query.contains("languages", curSearch.languages);
  }

  if (curSearch.genders.isNotEmpty) {
    query = query.in_("gender", curSearch.genders.toList());
  }
  if (curSearch.city != "") {
    query = query.eq("city", curSearch.city);
  }
  if (curSearch.maxAge != null) {
    query = query.lte('age', curSearch.maxAge);
  }
  if (curSearch.minAge != null) {
    query = query.gte('age', curSearch.minAge);
  }
  final List<dynamic> data = await query;
  List<Profile> res = [];
  for (var y in data) {
    try {
      res.add(parseProfile(parseLinkedMap(y)));
    } catch (e) {
      //showSnackBar(e.toString(), context);
    }
  }
  List<Profile> newRes = [];
  bool noConversationWithThisProfile;
  for (Profile y in res) {
    noConversationWithThisProfile = true;
    for (Conversation c in conversations) {
      if (c.destEmail == y.email) {
        noConversationWithThisProfile = false;
        break;
      }
    }
    if (noConversationWithThisProfile) {
      newRes.add(y);
    }
  }

  return newRes;
}

getSavedSearches(String searcher) async {
  PostgrestFilterBuilder query =
      supabase.from("search").select().eq("user", searcher);
  final List<dynamic> data = await query;
  List<SavedProfileSearch> res = [];
  for (LinkedHashMap x in data) {
    res.add(SavedProfileSearch(x.values.elementAt(9), parseSearch(x)));
  }

  return res;
}

parseSearch(x) {
  ProfileSearch s = ProfileSearch();
  s.maxAge = x.values.elementAt(2);
  s.minAge = x.values.elementAt(3);
  s.countries = parseList(x.values.elementAt(4));
  s.skills = parseList(x.values.elementAt(5));
  s.languages = parseList(x.values.elementAt(6));
  s.genders = parseList(x.values.elementAt(7));
  s.city = x.values.elementAt(8);
  return s;
}

parseList(x) {
  List<String> res = [];
  for (String y in x) {
    res.add(y);
  }
  return res;
}
