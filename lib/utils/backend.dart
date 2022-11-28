
import 'constants.dart';

Future<void> databaseInsert(String tableName, dynamic parameters) async {
  await supabase.from(tableName).insert(parameters);
}

List parseLinkedMap(l) {
  var newProfileFields = [];
  for (var profileField in l.values) {
    if (profileField != null) {
      newProfileFields.add(profileField);
    } else if (profileField == "") {
      newProfileFields.add("");
    } else {
      newProfileFields.add([]);
    }
  }
  return newProfileFields;
}
