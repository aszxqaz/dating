import 'package:collection/collection.dart';
import 'package:dating/interfaces/identifiable.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<_FeedEvent, FeedState> {
  FeedBloc() : super(FeedState.empty) {
    on<_FetchFeed>(_onFetchFeed);
    on<_FeedSubscribed>(_onFeedSubscribed);
    on<_FeedUnsubscribed>(_onFeedUnsubscribed);
    on<_FeedReceived>(_onFeedReceived);
  }

  static FeedBloc of(BuildContext context) => context.read<FeedBloc>();

  FutureVoidCallback? _unsubscribe;

  // ---
  // --- SUBSCRIBE FEED
  // ---
  Future<void> _onFeedSubscribed(
    _FeedSubscribed event,
    Emitter<FeedState> emit,
  ) async {
    _unsubscribe = await supabaseService.subscribeFeed(
      onData: (feed) {
        add(_FeedReceived(feeds: [feed]));
      },
    );
    debugPrint('[FeedBloc] subscribed');
  }

  // ---
  // --- UNSUBSCRIBE FEED
  // ---
  void _onFeedUnsubscribed(
      _FeedUnsubscribed event, Emitter<FeedState> emit) async {
    await _unsubscribe?.call();
    debugPrint('[FeedBloc] unsubscribed');
  }

  // ---
  // --- FETCH FEED
  // ---
  Future<void> _onFetchFeed(_FetchFeed event, Emitter<FeedState> emit) async {
    final fetched = await supabaseService.fetchFeed();
    if (fetched != null && fetched.isNotEmpty) {
      add(_FeedReceived(feeds: fetched));
    }
  }

  // ---
  // --- FEED RECEIVED
  // ---
  void _onFeedReceived(_FeedReceived event, Emitter<FeedState> emit) {
    final newFeeds = state.feeds
        .upsert(event.feeds)
        .sortedBy((feed) => feed.createdAt)
        .reversed
        .toList();

    debugPrint('[FeedBloc] received: ${event.feeds}');
    debugPrint('[FeedBloc] new feeds: $newFeeds');

    emit(state.copyWith(
      feeds: newFeeds,
      last: event.feeds,
    ));
  }

  // ---
  // --- PUBLIC API
  // ---
  void fetchFeed() {
    add(const _FetchFeed());
  }

  void subscribe() {
    add(const _FeedSubscribed());
  }

  void unsubscribe() {
    add(const _FeedUnsubscribed());
  }
}
