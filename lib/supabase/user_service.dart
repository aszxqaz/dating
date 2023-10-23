part of 'service.dart';

mixin _UserService on _BaseSupabaseService {
  // ---
  // --- UPDATE PREFERENCES
  // ---
  Future<bool?> updatePrefs(Preferences prefs) async {
    return tryExecute('[UserService.updatePrefs]', () async {
      await supabaseClient.from('preferences').upsert({
        'user_id': requireUserId,
        'p_user_id': requireUserId,
        ...prefs.toJson()
      });
      return true;
    });
  }

  // ---
  // --- UPDATE LAST SEEN
  // ---
  Future<bool?> updateLastSeen() async {
    return tryExecute('[UserService.updateLastSeen]', () async {
      await supabaseClient
          .from('profiles')
          .update({'last_seen': DateTime.now().toUtc().toIso8601String()}).eq(
              'user_id', requireUser.id);
      return true;
    });
  }

  // ---
  // --- UPDATE QUOTE (STATUS)
  // ---
  Future<bool?> updateqQuote(String quote) async {
    return tryExecute('[UserService.updateqQuote]', () async {
      await supabaseClient
          .from('profiles')
          .update({'quote': quote}).eq('user_id', requireUser.id);
      return true;
    });
  }
}
