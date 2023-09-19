part of 'service.dart';

mixin _ProfileService on _BaseSupabaseService {
  Future<ProfileTable?> findProfileByUserId([String? userId]) async {
    final id = userId ?? globalUser?.id;
    if (id == null) return null;

    final json = await supabaseClient
        .from('profiles')
        .select<Map<String, dynamic>?>()
        .eq('user_id', id)
        .maybeSingle();

    if (json == null) return null;

    return ProfileTable.fromJson(json);
  }

  Future<List<Profile>> findAllProfiles() async {
    if (globalUser == null) return [];

    final list = await supabaseClient.from('profiles').select<List>('''
      *,
      photos (*),
      locations (*)
    ''');

    final profiles = (list.cast<Map<String, dynamic>>())
        .map((profile) => Profile.fromJson(profile))
        .toList();

    debugPrint('--- FETCHED PROFILES: ${profiles.toString()}');

    return profiles;
  }
}
