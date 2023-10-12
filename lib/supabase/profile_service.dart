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

  // ---
  // --- CREATE PROFILE
  // ---
  Future<Profile?> createProfile(DateTime birthdate, String name) async {
    return tryExecute('createProfile', () async {
      return await supabaseClient.from('profiles').insert({
        'user_id': requireUserId,
        'name': name,
        'birthdate': birthdate.toUtc().toIso8601String(),
      }).select();
    });
  }

  // ---
  // --- FETCH USER PROFILE
  // ---
  Future<Profile?> fetchUserProfile() async {
    return tryExecute('fetchUserProfile', () async {
      debugPrint(
          '[ProfileService] fetching user profile with user_id: $requireUserId');
      final json = await supabaseClient
          .from('profiles')
          .select<Map<String, dynamic>>(profileQuery)
          .eq('user_id', requireUserId)
          .single();

      return Profile.fromJson(json);
    });
  }

  // ---
  // --- FETCH PROFILE BY USER ID
  // ---
  Future<Profile?> fetchProfile(String userId) async {
    return tryExecute('findProfileByUserId', () async {
      final json = await supabaseClient
          .from('profiles')
          .select<Map<String, dynamic>>(profileQuery)
          .eq('user_id', userId)
          .single();

      return Profile.fromJson(json);
    });
  }

  // ---
  // --- FETCH MANY PROFILES
  // ---
  Future<List<Profile>?> fetchProfiles(List<String> profileIds) async {
    return tryExecute('findProfiles', () async {
      final json = await supabaseClient
          .from('profiles')
          .select<List<Map<String, dynamic>>>(profileQuery)
          .in_('user_id', profileIds);

      return json.map(Profile.fromJson).toList();
    });
  }

  // ---
  // --- FETCH ALL PROFILES
  // ---
  Future<List<Profile>?> fetchCardsProfiles() async {
    return tryExecute('findAllProfiles', () async {
      final list = await supabaseClient
          .from('profiles')
          .select<List<Map<String, dynamic>>>(profileQuery)
          .neq('user_id', globalUser!.id);

      final profiles = list.map(Profile.fromJson).toList();

      return profiles;
    });
  }

  // ---
  // --- UPDATE LAST SEEN
  // ---
  Future<bool?> updateLastSeen() async {
    return tryExecute('updateLastSeen', () async {
      await supabaseClient
          .from('profiles')
          .update({'last_seen': DateTime.now().toUtc().toIso8601String()}).eq(
              'user_id', requireUser.id);
      return true;
    });
  }
}
