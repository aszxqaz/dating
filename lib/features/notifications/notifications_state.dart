part of 'notifications_bloc.dart';

@immutable
class NotificationsState {
  const NotificationsState({
    required this.likes,
    required this.last,
  });

  static const empty = NotificationsState(likes: [], last: []);

  final List<LikeNotification> likes;
  final List<LikeNotification> last;

  int get unreadCount => likes.where((like) => !like.read).length;

  NotificationsState copyWith({
    List<LikeNotification>? likes,
    List<LikeNotification>? last,
  }) =>
      NotificationsState(
        likes: likes ?? this.likes,
        last: last ?? this.last,
      );
}
