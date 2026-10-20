import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/supabase_profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Profile> createProfile(Profile profile) {
    return _dataSource.insert(profile);
  }
}
