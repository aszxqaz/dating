part of 'notifications_bloc.dart';

sealed class _NotificationsEvent {
  const _NotificationsEvent();
}

final class _FetchLikes extends _NotificationsEvent {
  const _FetchLikes();
}

final class _SubscriptionRequested extends _NotificationsEvent {
  const _SubscriptionRequested();
}

// final class _Unsubscribed extends _NotificationsEvent {
//   const _Unsubscribed();
// }

final class _LikesReceived extends _NotificationsEvent {
  const _LikesReceived({required this.likes});

  final List<LikeNotification> likes;
}

final class _ReadUnread extends _NotificationsEvent {
  const _ReadUnread();
}
