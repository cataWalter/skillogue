import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = SupabaseClient(
  "https://yngloibojslkksjxnieo.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InluZ2xvaWJvanNsa2tzanhuaWVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjkzMTE2NDUsImV4cCI6MTk4NDg4NzY0NX0.tTZqggCePAuBr9hGICNmeMQcgmFuwaZT_jbUtRFLmeE",
);

Future<void> databaseInsert(String tableName, dynamic parameters) async {
  await supabase.from(tableName).insert(parameters);
}

List parseLinkedMap(l) {
  var newProfileFields = [];
  for (var field in l.values) {
    if (field != null) {
      newProfileFields.add(field);
    } else if (field == "") {
      newProfileFields.add("");
    } else {
      newProfileFields.add([]);
    }
  }
  return newProfileFields;
}
