import 'package:dating/misc/uuid.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:uuid/uuid.dart';

class ChatMessage {
  ChatMessage({
    String? id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.read,
    this.createdAt,
  }) : id = id ?? uuid.v4();

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        chatId: json['chat_id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        text: json['text'],
        read: json['read'],
        createdAt: DateTime.parse(json['created_at']),
      );

  final String id;
  final String chatId;
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime? createdAt;
  final bool read;

  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? text,
    String? senderId,
    String? receiverId,
    DateTime? createdAt,
    bool? read,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        text: text ?? this.text,
        read: read ?? this.read,
      );
}

class Chat {
  Chat({
    String? id,
    required this.partner,
    required this.messages,
  }) : id = id ?? uuid.v4();

  final String id;
  final Profile partner;
  final List<ChatMessage> messages;

  Chat copyWith({
    String? id,
    Profile? partner,
    List<ChatMessage>? messages,
  }) =>
      Chat(
        id: id ?? this.id,
        partner: partner ?? this.partner,
        messages: messages ?? this.messages,
      );

  Chat withNewMessages(List<ChatMessage> newMessages) => copyWith(
        messages: [...messages, ...newMessages],
      );

  Chat withoutMessage(String messageId) => copyWith(
        messages: messages.where((m) => m.id != messageId).toList(),
      );

  Chat withReadMessagesStatus(List<String> messageIds, bool read) => copyWith(
        messages: messages
            .map(
              (message) => messageIds.contains(message.id)
                  ? message.copyWith(read: read)
                  : message,
            )
            .toList(),
      );

  bool get containsUnread => messages
      .any((message) => !message.read && message.senderId == partner.userId);
}
