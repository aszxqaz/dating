part of 'models.dart';

class LikeNotification {
  const LikeNotification({
    required this.photoId,
    required this.senderId,
    required this.createdAt,
    required this.read,
  });

  final String photoId;
  final String senderId;
  final DateTime createdAt;
  final bool read;

  factory LikeNotification.fromJson(Map<String, dynamic> json) =>
      LikeNotification(
        photoId: json['photo_id'],
        senderId: json['sender_id'],
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        read: json['read'] as bool,
      );

  LikeNotification read_() => LikeNotification(
        photoId: photoId,
        senderId: senderId,
        createdAt: createdAt,
        read: true,
      );
}
