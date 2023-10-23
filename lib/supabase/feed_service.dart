part of 'service.dart';

mixin _FeedService on _BaseSupabaseService {
  // ---
  // --- FETCH THE FEED
  // ---
  Future<List<FeedChannelModel>?> fetchFeed() async {
    return tryExecute('fetchFeed', () async {
      final json = await supabaseClient
          .from('feed')
          .select<List<Map<String, dynamic>>>()
          .neq('sender_id', requireUserId)
          .order('created_at');

      final feed = json
          .map(
            (json) => FeedChannelModel.fromJson(json),
          )
          .toList();

      return feed;
    });
  }

  // ---
  // --- SUBSCRIBE FEED
  // ---
  FutureOr<FutureVoidCallback?> subscribeFeed({
    required void Function(FeedChannelModel feed) onData,
  }) {
    final filter = 'sender_id=neq.$requireUserId';

    return tryExecute('subscribeFeed', () async {
      final channel = createChannel('feed')
        ..on_(
          table: 'feed',
          filter: filter,
          event: 'INSERT',
          onData: (json) {
            final feed = FeedChannelModel.fromJson(json);
            onData(feed);
          },
        );

      channel.subscribe();

      return () async {
        await channel.unsubscribe();
      };
    });
  }
}
