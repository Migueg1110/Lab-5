/// Las claves NO van escritas en el código (así no se suben a GitHub).
/// Se pasan al ejecutar con --dart-define. Ver README.
class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
