part of 'feed_bloc.dart';

sealed class _FeedEvent {
  const _FeedEvent();
}

class _FetchFeed extends _FeedEvent {
  const _FetchFeed();
}

class _FeedSubscribed extends _FeedEvent {
  const _FeedSubscribed();
}

class _FeedUnsubscribed extends _FeedEvent {
  const _FeedUnsubscribed();
}

class _FeedReceived extends _FeedEvent {
  const _FeedReceived({required this.feeds});

  final List<FeedChannelModel> feeds;
}
