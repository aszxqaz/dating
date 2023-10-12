part of 'service.dart';

mixin _PreferenceService on _BaseSupabaseService {
  Future<bool?> updatePrefs(Preferences prefs) async {
    return tryExecute('updatePrefs', () async {
      await supabaseClient.from('preferences').upsert({
        'user_id': requireUserId,
        'p_user_id': requireUserId,
        ...prefs.toJson()
      });
      return true;
    });
  }
}
