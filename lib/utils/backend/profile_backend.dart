import '../../entities/profile.dart';
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
  );
}

Future<Profile> findProfileByEmail(String email) async {
  final List<dynamic> data =
      await supabase.from('profile').select().eq('email', email);
  return parseProfile(parseLinkedMap(data[0]));
}
