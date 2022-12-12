import 'package:skillogue/utils/backend/profile_backend.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../entities/conversation.dart';
import '../../entities/profile.dart';
import '../../entities/profile_search.dart';
import 'misc_backend.dart';

Future<List<Profile>> findUsers(String searcher, ProfileSearch curSearch,
    List<Conversation> conversations) async {
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
  query = query.gte('age', curSearch.minAge);
  query = query.lte('age', curSearch.maxAge);

  final List<dynamic> data = await query;
  List<Profile> res = [];
  for (var y in data) {
    res.add(parseProfile(parseLinkedMap(y)));
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
