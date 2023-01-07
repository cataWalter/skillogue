import 'package:supabase_flutter/supabase_flutter.dart';

import 'misc_backend.dart';

Future<bool> notExistsUsersWithSameEmail(String email) async {
  try {
    final List<dynamic> data =
        await supabase.from('profile').select().eq('email', email);
    return data.isEmpty;
  } catch (e) {
    return false;
  }
}

Future<AuthResponse> login(String email, String password) async {
  try {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    return AuthResponse();
  }
}

Future<AuthResponse> registration(String email, String password) async {
  try {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  } catch (e) {
    return AuthResponse();
  }
}

void loginDateUpdate(email) async {
  await supabase.from('profile').update(
      {'last_login': DateTime.now().toString()}).match({'email': email});
}
