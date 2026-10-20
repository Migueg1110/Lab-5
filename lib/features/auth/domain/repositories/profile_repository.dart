import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> createProfile(Profile profile);
}
