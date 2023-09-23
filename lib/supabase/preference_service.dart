part of 'service.dart';

mixin _PreferenceService on _BaseSupabaseService {
  Future<bool> updatePrefs(Preferences prefs) async {
    final userId = globalUser?.id;
    if (userId == null) return false;

    try {
      await supabaseClient.from('preferences').upsert({
        'user_id': userId,
        'p_user_id': userId,
        ...prefs.toJson()
      }).eq('user_id', userId);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    return true;
  }
}
