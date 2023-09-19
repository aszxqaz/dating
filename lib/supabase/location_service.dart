part of 'service.dart';

mixin _LocationService on _BaseSupabaseService {
  Future<UserLocation?> findLocationByUserId([String? userId]) async {
    final id = userId ?? globalUser?.id;
    if (id == null) return null;

    final data = await supabaseClient
        .from('locations')
        .select<Map<String, dynamic>?>()
        .eq('user_id', id)
        .maybeSingle();

    if (data == null) return null;

    return UserLocation.fromJson(data);
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    required String country,
    required String city,
  }) async {
    final userId = globalUser?.id;
    if (userId == null) return;

    try {
      await supabaseClient.from('locations').upsert({
        'user_id': userId,
        'p_user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
        'country': country,
        'city': city,
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
