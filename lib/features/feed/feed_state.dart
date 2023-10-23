part of 'feed_bloc.dart';

class FeedState {
  const FeedState({
    required this.feeds,
    required this.last,
  });

  final List<FeedChannelModel> feeds;
  final List<FeedChannelModel> last;

  static const empty = FeedState(
    feeds: [],
    last: [],
  );

  FeedState copyWith({
    List<FeedChannelModel>? feeds,
    List<FeedChannelModel>? last,
  }) =>
      FeedState(
        feeds: feeds ?? this.feeds,
        last: last ?? this.last,
      );
}
