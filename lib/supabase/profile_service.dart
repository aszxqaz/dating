part of 'service.dart';

class FetchUserProfileResponse {
  const FetchUserProfileResponse({required this.profile});
  final Profile? profile;
}

class CreateProfileArgs {
  const CreateProfileArgs({required this.birthdate, required this.name});
  final DateTime birthdate;
  final String name;
}

mixin _ProfileService on _SupabaseService {
  static const profileQuery = '''
    *,
    photos (
      *, photo_likes (
        *
      )
    ),
    locations (*),
    preferences (*)
  ''';

  static const _service = '[ProfileService]';

  // ---
  // --- CREATE PROFILE
  // ---
  Future<Profile?> createProfile(
    DateTime birthdate,
    Gender gender,
    String name,
  ) async {
    return tryExecute('$_service createProfile', () async {
      final json = await supabaseClient
          .from('profiles')
          .insert({
            'user_id': requireUserId,
            'name': name,
            'birthdate': birthdate.toUtc().toIso8601String(),
            'gender': gender.name,
          })
          .select<PostgrestMap>()
          .single();

      debugPrint('[ProfileService] profile created: ${jsonEncode(json)}');

      return Profile.fromJson(json);
    });
  }

  // ---
  // --- FETCH USER PROFILE
  // ---
  Future<Profile?> fetchUserProfile() async {
    return tryExecute('$_service fetchUserProfile', () async {
      debugPrint(
          '[ProfileService] fetching user profile with user_id: $requireUserId');
      final json = await supabaseClient
          .from('profiles')
          .select<PostgrestMap>(profileQuery)
          .eq('user_id', requireUserId)
          .single();

      return Profile.fromJson(json);
    });
  }

  // ---
  // --- FETCH PROFILE BY USER ID
  // ---
  Future<Profile?> fetchProfile(String userId) async {
    return tryExecute('$_service findProfile', () async {
      final json = await supabaseClient
          .from('profiles')
          .select<PostgrestMap>(profileQuery)
          .eq('user_id', userId)
          .single();

      return Profile.fromJson(json);
    });
  }

  // ---
  // --- FETCH MANY PROFILES
  // ---
  Future<List<Profile>?> fetchProfiles(List<String> profileIds) async {
    return tryExecute('$_service findProfiles', () async {
      final json = await supabaseClient
          .from('profiles')
          .select<List<PostgrestMap>>(profileQuery)
          .in_('user_id', profileIds);

      return json.map(Profile.fromJson).toList();
    });
  }

  // ---
  // --- FETCH ALL PROFILES
  // ---
  Future<List<Profile>?> fetchCardsProfiles() async {
    return tryExecute('$_service findAllProfiles', () async {
      final list = await supabaseClient
          .from('profiles')
          .select<List<PostgrestMap>>(profileQuery)
          .neq('user_id', requireUserId);

      final profiles = list.map(Profile.fromJson).toList();

      return profiles;
    });
  }
}
