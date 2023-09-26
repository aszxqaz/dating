part of 'service.dart';

mixin _ProfileService on _BaseSupabaseService {
  Future<Profile?> findProfileByUserId([String? userId]) async {
    final id = userId ?? globalUser?.id;
    if (id == null) return null;

    final json =
        await supabaseClient.from('profiles').select<Map<String, dynamic>?>('''
          *,
          photos (*),
          locations (*),
          preferences (*)
        ''').eq('user_id', id).maybeSingle();

    if (json == null) return null;

    return Profile.fromJson(json);
  }

  Future<List<Profile>> findAllProfiles() async {
    if (globalUser == null) return [];

    final list = await supabaseClient.from('profiles').select<List>('''
      *,
      photos (
        *, photo_likes (
          *
        )
      ),
      locations (*),
      preferences (*)
    ''').neq('user_id', globalUser!.id);

    final profiles = (list.cast<Map<String, dynamic>>())
        .map((profile) => Profile.fromJson(profile))
        .toList();

    debugPrint('--- FETCHED PROFILES: ${profiles.toString()}');

    for (final profile in profiles) {
      debugPrint(
          '--- FETCHED PHOTOS: ${profile.photos.map((p) => p.likes).toString()}');
    }

    return profiles;
  }
}
