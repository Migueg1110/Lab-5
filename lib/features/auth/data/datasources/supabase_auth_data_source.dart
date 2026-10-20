import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/sign_up_exception.dart';

/// Único lugar que llama a Supabase Auth.
class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const SignUpException('No se pudo crear la cuenta');
      }
      return AuthUser(id: user.id, email: user.email ?? email);
    } on AuthException catch (e) {
      throw SignUpException(e.message);
    }
  }
}
