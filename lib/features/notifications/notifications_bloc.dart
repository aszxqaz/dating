import 'package:dating/supabase/models/notification.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<_NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsState.empty) {
    on<_FetchLikes>(_onFetchLikes);
    on<_SubscriptionRequested>(_onSubscriptionRequested);
    on<_LikesReceived>(_onLikeNotificationsReceived);
    on<_ReadUnread>(_onReadUnread);
  }

  FutureVoidCallback? _unsubscribeLikeNotifications;

  static NotificationsBloc of(BuildContext context) =>
      context.read<NotificationsBloc>();

  // ---
  // --- LIFECYCLE
  // ---
  @override
  close() async {
    await _unsubscribeLikeNotifications?.call();
    super.close();
  }

  // ---
  // --- FETCH (ALL) LIKE NOTIFICATIONS
  // ---
  void _onFetchLikes(
    _FetchLikes event,
    Emitter<NotificationsState> emit,
  ) async {
    final likes = await supabaseService.fetchLikeNotifications();
    if (likes != null) {
      add(_LikesReceived(likes: likes));
    }
  }

  // ---
  // --- LIKE NOTIFICATIONS SUBSCRIPTION
  // ---
  void _onSubscriptionRequested(
    _SubscriptionRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    _unsubscribeLikeNotifications =
        await supabaseService.subscribeLikeNotifications(
      onData: (like) {
        add(_LikesReceived(likes: [like]));
      },
    );
  }

  // ---
  // --- LIKE NOTIFICATIONS RECEIVED
  // ---
  void _onLikeNotificationsReceived(
    _LikesReceived event,
    Emitter<NotificationsState> emit,
  ) {
    debugPrint('Notifications received: length: ${event.likes.length}');
    final likes = event.likes + state.likes;
    emit(state.copyWith(likes: likes, last: event.likes));
  }

  // ---
  // --- READ UNREAD NOTIFICATIONS
  // ---
  void _onReadUnread(
    _ReadUnread event,
    Emitter<NotificationsState> emit,
  ) {
    final likes =
        state.likes.map((like) => !like.read ? like.read_() : like).toList();
    emit(state.copyWith(likes: likes));
  }

  // ---
  // --- PUBLIC API
  // ---
  void fetchLikeNotifications() {
    add(const _FetchLikes());
  }

  void requestSubscription() {
    add(const _SubscriptionRequested());
  }

  void readUnread() {
    add(const _ReadUnread());
  }
}
