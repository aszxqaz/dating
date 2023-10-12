part of 'service.dart';

mixin _NotificationService on _BaseSupabaseService {
  /// ---
  /// --- SUBSCRIBE LIKE NOTIFICATIONS
  /// ---
  FutureOr<FutureVoidCallback?> subscribeLikeNotifications({
    required void Function(LikeNotification like) onData,
  }) {
    return tryExecute('subscribeLikeNotifications', () async {
      final channel = createChannel('like_notifications').on_(
        table: 'like_notifications',
        filter: 'receiver_id=eq.$requireUserId',
        event: 'INSERT',
        onData: (json) {
          final like = LikeNotification.fromJson(json);
          onData(like);
        },
      );

      channel.subscribe();

      return () async {
        await channel.unsubscribe();
      };
    });
  }

  /// ---
  /// --- FETCH (ALL) LIKE NOTIFICATIONS
  /// ---
  FutureOr<List<LikeNotification>?> fetchLikeNotifications() {
    return tryExecute('fetchLikeNotifications', () async {
      final json = await supabaseClient
          .from('like_notifications')
          .select<JsonList>()
          .eq('receiver_id', requireUserId)
          .order('created_at');

      return json.map(LikeNotification.fromJson).toList();
    });
  }
}
