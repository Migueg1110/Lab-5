/// Error del dominio. La capa de datos traduce las excepciones de Supabase
/// a esta, para que de ahí hacia arriba nadie conozca clases del SDK.
class SignUpException implements Exception {
  final String message;
  const SignUpException(this.message);

  @override
  String toString() => message;
}
