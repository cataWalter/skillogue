import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';

Future<bool> existsUsersWithSameEmail(String email) async {
  final List<dynamic> data =
      await supabase.from('profile').select().eq('email', email);
  return data.isEmpty;
}

Future<AuthResponse> login(String email, String password) async {
  return await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );
}

Future<AuthResponse> registration(String email, String password) async {
  return await supabase.auth.signUp(
    email: email,
    password: password,
  );
}

void loginDateUpdate(email) async {
  await supabase.from('profile').update(
      {'last_login': DateTime.now().toString()}).match({'email': email});
}
