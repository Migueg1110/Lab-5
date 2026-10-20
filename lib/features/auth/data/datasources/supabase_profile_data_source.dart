import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile.dart';
import '../../domain/sign_up_exception.dart';

/// Único lugar que llama a la tabla `profiles`.
class SupabaseProfileDataSource {
  final SupabaseClient _client;

  SupabaseProfileDataSource(this._client);

  Future<Profile> insert(Profile profile) async {
    try {
      await _client.from('profiles').insert({
        'id': profile.id,
        'username': profile.username,
        'full_name': profile.fullName,
        'email': profile.email,
      });
      return profile;
    } on PostgrestException catch (e) {
      throw SignUpException(e.message);
    }
  }
}
