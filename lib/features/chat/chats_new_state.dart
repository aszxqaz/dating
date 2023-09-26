part of 'chats_new_bloc.dart';

final class ChatsNewState {
  const ChatsNewState({required this.chats});

  static const initial = ChatsNewState(chats: []);

  final List<ChatNew> chats;

  ChatsNewState withNewChats(List<ChatNew> chats) {
    final newChats = [...chats, ...chats];
    return ChatsNewState(chats: newChats);
  }

  ChatsNewState upsertMessages(List<ChatMessageNew> messages) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _chats = chats;

    for (final message in messages) {
      final partnerId =
          message.incoming ? message.senderId : message.receiverId;

      final index = _chats.indexWhere((chat) => chat.partnerId == partnerId);

      if (index != -1) {
        final chat = _chats[index].upsert([message]);

        _chats = _chats.slice(0, index) + [chat] + _chats.slice(index + 1);
      } else {
        final chat = ChatNew(partnerId: partnerId, messages: [message]);

        _chats = [chat, ..._chats];
      }
    }

    return ChatsNewState(chats: _chats);
  }

  ChatsNewState withoutMessage(String partnerId, String messageId) {
    final index = indexByPartnerId(partnerId);
    if (index == -1) {
      debugPrint(
          'ERROR: withoutMessage() didnt find chat with partnerId $partnerId');
      return this;
    }

    final newChat = chats[index].withoutMessage(messageId);
    final newChats = chats.slice(0, index) + [newChat] + chats.slice(index + 1);
    return ChatsNewState(chats: newChats);
  }

  ChatsNewState withoutChat(String partnerId) {
    final index = indexByPartnerId(partnerId);
    if (index == -1) return this;

    final newChats = chats.slice(0, index) + chats.slice(index + 1);
    return ChatsNewState(chats: newChats);
  }

  ChatsNewState withMessagesReadStatus(
    String partnerId,
    List<String> messageIds,
    bool read,
  ) {
    final index = indexByPartnerId(partnerId);
    if (index == -1) return this;

    final newChat = chats[index].withReadMessagesStatus(messageIds, read);
    final newChats = chats.slice(0, index) + [newChat] + chats.slice(index + 1);

    return ChatsNewState(chats: newChats);
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
  ChatNew? getChatByPartnerId(String partnerId) =>
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
}
