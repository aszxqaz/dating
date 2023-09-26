import 'package:collection/collection.dart';
import 'package:dating/misc/uuid.dart';

class ChatNew {
  const ChatNew({
    required this.partnerId,
    this.messages = const [],
  });

  final String partnerId;
  final List<ChatMessageNew> messages;

  ChatNew copyWith({
    List<ChatMessageNew>? messages,
  }) =>
      ChatNew(
        partnerId: partnerId,
        messages: messages ?? this.messages,
      );

  ChatNew upsert(List<ChatMessageNew> newMessages) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _messages = messages;

    for (final message in newMessages) {
      final index = indexByMessageId(message.id);

      if (index == -1) {
        _messages = [..._messages, message];
      } else {
        _messages =
            _messages.slice(0, index) + [message] + _messages.slice(index + 1);
      }
    }

    return copyWith(messages: _messages);
  }

  ChatNew withoutMessage(String messageId) => copyWith(
        messages: messages.where((m) => m.id != messageId).toList(),
      );

  ChatNew withReadMessagesStatus(List<String> messageIds, bool read) =>
      copyWith(
        messages: messages
            .map(
              (message) => messageIds.contains(message.id)
                  ? message.copyWith(read: read)
                  : message,
            )
            .toList(),
      );

  bool get containsUnread =>
      messages.any((message) => !message.read && message.senderId == partnerId);

  List<ChatMessageNew> get unreadIncoming =>
      messages.where((m) => !m.read && m.incoming).toList();

  int indexByMessageId(String messageId) =>
      messages.indexWhere((message) => message.id == messageId);
}

class ChatMessageNew {
  ChatMessageNew({
    String? id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.read,
    required this.incoming,
    this.createdAt,
  }) : id = id ?? uuid.v4();

  factory ChatMessageNew.fromJson(Map<String, dynamic> json,
          {required bool incoming}) =>
      ChatMessageNew(
        id: json['id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        text: json['text'],
        read: json['read'],
        createdAt: DateTime.parse(json['created_at']),
        incoming: incoming,
      );

  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime? createdAt;
  final bool read;
  final bool incoming;

  ChatMessageNew copyWith({
    String? text,
    DateTime? createdAt,
    bool? read,
  }) =>
      ChatMessageNew(
        id: id,
        senderId: senderId,
        receiverId: receiverId,
        incoming: incoming,
        createdAt: createdAt ?? this.createdAt,
        text: text ?? this.text,
        read: read ?? this.read,
      );
}
