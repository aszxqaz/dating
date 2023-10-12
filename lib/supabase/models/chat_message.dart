part of 'models.dart';

class ChatMessage {
  ChatMessage({
    String? id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.read,
    required this.incoming,
    required this.sent,
    required this.createdAt,
  }) : id = id ?? uuid.v4();

  factory ChatMessage.fromJson(Map<String, dynamic> json,
          {required bool incoming}) =>
      ChatMessage(
        id: json['id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        text: json['text'],
        read: json['read'],
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        incoming: incoming,
        sent: true,
      );

  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;
  final bool read;
  final bool sent;
  final bool incoming;

  ChatMessage copyWith({
    String? text,
    DateTime? createdAt,
    bool? read,
    bool? sent,
  }) =>
      ChatMessage(
        id: id,
        senderId: senderId,
        receiverId: receiverId,
        incoming: incoming,
        createdAt: createdAt ?? this.createdAt,
        text: text ?? this.text,
        read: read ?? this.read,
        sent: sent ?? this.sent,
      );
}
