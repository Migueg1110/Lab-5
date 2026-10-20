import '../entities/profile.dart';
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';

/// Decide el ORDEN: primero la cuenta, después el perfil.
/// Solo conoce contratos, no sabe que existe Supabase.
class SignUpUseCase {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  SignUpUseCase(this._authRepository, this._profileRepository);

  Future<Profile> call({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    // 1. Crear la cuenta. Si lanza excepción, el perfil ni se intenta.
    final authUser = await _authRepository.signUp(
      email: email,
      password: password,
    );

    // 2. El Profile se arma con el id que devolvió Auth.
    final profile = Profile(
      id: authUser.id,
      username: username,
      fullName: fullName,
      email: authUser.email,
    );

    // 3. Guardar el perfil.
    return _profileRepository.createProfile(profile);
  }
}
