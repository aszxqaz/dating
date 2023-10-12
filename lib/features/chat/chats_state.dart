part of 'chats_bloc.dart';

final class ChatsState {
  const ChatsState({
    required this.chats,
    required this.last,
  });

  static const empty = ChatsState(chats: [], last: []);

  final List<Chat> chats;
  final List<Chat> last;

  ChatsState upsertMessages(List<ChatMessage> messages) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _chats = chats;
    // ignore: no_leading_underscores_for_local_identifiers
    List<Chat> _last = [];

    for (final message in messages) {
      final partnerId =
          message.incoming ? message.senderId : message.receiverId;

      final index = _chats.indexWhere((chat) => chat.partnerId == partnerId);

      if (index != -1) {
        final chat = _chats[index].upsert([message]);

        _chats = _chats.slice(0, index) + [chat] + _chats.slice(index + 1);
      } else {
        final chat = Chat(partnerId: partnerId, messages: [message]);

        _last = _last + [chat];

        _chats = [chat] + _chats;
      }
    }

    return ChatsState(chats: _chats, last: _last);
  }

  ChatsState withoutMessage(String partnerId, String messageId) {
    final index = indexByPartnerId(partnerId);
    if (index == -1) {
      debugPrint(
          'ERROR: withoutMessage() didnt find chat with partnerId $partnerId');
      return this;
    }

    final newChat = chats[index].withoutMessage(messageId);
    final newChats = chats.slice(0, index) + [newChat] + chats.slice(index + 1);
    return copyWith(chats: newChats);
  }

  ChatsState withoutChat(String partnerId) {
    final index = indexByPartnerId(partnerId);
    if (index == -1) return this;

    final newChats = chats.slice(0, index) + chats.slice(index + 1);
    return copyWith(chats: newChats);
  }

  ChatsState withMessagesReadStatus(
    String partnerId,
    List<String> messageIds,
    bool read,
  ) {
    final index = indexByPartnerId(partnerId);
    if (index == -1) return this;

    final newChat = chats[index].withReadMessagesStatus(messageIds, read);
    final newChats = chats.slice(0, index) + [newChat] + chats.slice(index + 1);

    return copyWith(chats: newChats);
  }

  // stable
  List<String> messageIdsUnreadIncoming(String partnerId) {
    final chat = getChatByPartnerId(partnerId);
    if (chat == null) {
      debugPrint(
          'ERROR: messageIdsUnreadIncoming() didnt find chat with partnerId $partnerId');
      return [];
    }

    return chat.unreadIncoming.map((message) => message.id).toList();
  }

  // stable
  Chat? getChatByPartnerId(String partnerId) =>
      chats.firstWhereOrNull((chat) => chat.partnerId == partnerId);

  bool includesPartner(String partnerId) =>
      chats.any((chat) => chat.partnerId == partnerId);

  int indexByPartnerId(String partnerId) =>
      chats.indexWhere((chat) => chat.partnerId == partnerId);

  int get unreadCount => chats.fold(
        0,
        (sum, chat) =>
            sum +
            chat.messages.fold(
              0,
              (sum, message) =>
                  sum + (!message.read && message.incoming ? 1 : 0),
            ),
      );

  ChatsState copyWith({
    List<Chat>? chats,
    List<Chat>? last,
  }) =>
      ChatsState(
        chats: chats ?? this.chats,
        last: last ?? this.last,
      );
}
