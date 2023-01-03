import '../../entities/profile_entity.dart';
import 'misc_backend.dart';

Profile parseProfile(List newProfileFields) {
  return Profile(
    newProfileFields[0],
    newProfileFields[1],
    newProfileFields[2],
    newProfileFields[3],
    newProfileFields[4],
    newProfileFields[5],
    DateTime.parse(newProfileFields[6]),
    List<String>.from(newProfileFields[7]),
    List<String>.from(newProfileFields[8]),
    newProfileFields[9],
  );
}

Future<Profile> findProfileByEmail(String email) async {
  final List<dynamic> data =
      await supabase.from('profile').select().eq('email', email);
  return parseProfile(parseLinkedMap(data[0]));
}

void updateProfile(String email, parameters) async {
  await supabase.from('profile').update(parameters).eq('email', email);
}

Future<List<String>> getBlocked(String email) async {
  final List<dynamic> data =
      await supabase.from('block').select().eq('blocker', email);
  List<String> res = [];
  for (var el in data) {
    res.add(parseLinkedMap(el)[2]);
  }
  return res;
}

Future<List<String>> getBlockedBy(String email) async {
  final List<dynamic> data =
      await supabase.from('block').select().eq('blocked', email);
  List<String> res = [];
  for (var el in data) {
    res.add(parseLinkedMap(el)[1]);
  }
  return res;
}
