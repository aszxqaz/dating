part of 'models.dart';

class Chat extends Identifiable {
  Chat({
    required this.partnerId,
    this.messages = const [],
  }) : super(id: partnerId);

  final String partnerId;
  final List<ChatMessage> messages;

  // ---
  // --- GETTERS
  // ---
  bool get containsUnread =>
      messages.any((message) => !message.read && message.senderId == partnerId);

  List<ChatMessage> get unreadIncoming =>
      messages.where((m) => !m.read && m.incoming).toList();

  ChatMessage get lastMessage => messages.last;

  ChatMessage? getChatMessage(String id) =>
      messages.singleWhereOrNull((msg) => msg.id == id);

  // ---
  // --- METHODS
  // ---

  Chat copyWith({
    List<ChatMessage>? messages,
  }) =>
      Chat(
        partnerId: partnerId,
        messages: messages ?? this.messages,
      );

  Chat upsert(List<ChatMessage> newMessages) {
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

  int indexByMessageId(String messageId) =>
      messages.indexWhere((message) => message.id == messageId);
}
