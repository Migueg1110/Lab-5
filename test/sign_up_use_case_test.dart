import 'package:flutter_test/flutter_test.dart';
import 'package:registro_clean/features/auth/domain/entities/auth_user.dart';
import 'package:registro_clean/features/auth/domain/entities/profile.dart';
import 'package:registro_clean/features/auth/domain/repositories/auth_repository.dart';
import 'package:registro_clean/features/auth/domain/repositories/profile_repository.dart';
import 'package:registro_clean/features/auth/domain/sign_up_exception.dart';
import 'package:registro_clean/features/auth/domain/usecases/sign_up_use_case.dart';

class _FakeAuth implements AuthRepository {
  final List<String> log;
  final bool fails;
  _FakeAuth(this.log, {this.fails = false});

  @override
  Future<AuthUser> signUp({required String email, required String password}) async {
    log.add('auth');
    if (fails) throw const SignUpException('User already registered');
    return AuthUser(id: 'uid-1', email: email);
  }
}

class _FakeProfiles implements ProfileRepository {
  final List<String> log;
  Profile? saved;
  _FakeProfiles(this.log);

  @override
  Future<Profile> createProfile(Profile profile) async {
    log.add('profile');
    saved = profile;
    return profile;
  }
}

void main() {
  test('crea la cuenta primero y luego el perfil con el id de Auth', () async {
    final log = <String>[];
    final profiles = _FakeProfiles(log);
    final useCase = SignUpUseCase(_FakeAuth(log), profiles);

    final result = await useCase(
      username: 'ana',
      fullName: 'Ana Gómez',
      email: 'ana@icesi.edu.co',
      password: '123456',
    );

    expect(log, ['auth', 'profile']);
    expect(result.id, 'uid-1');
    expect(profiles.saved?.username, 'ana');
  });

  test('si signUp falla, el perfil no se intenta', () async {
    final log = <String>[];
    final useCase = SignUpUseCase(
      _FakeAuth(log, fails: true),
      _FakeProfiles(log),
    );

    await expectLater(
      useCase(
        username: 'ana',
        fullName: 'Ana Gómez',
        email: 'ana@icesi.edu.co',
        password: '123456',
      ),
      throwsA(isA<SignUpException>()),
    );

    expect(log, ['auth']);
  });
}
