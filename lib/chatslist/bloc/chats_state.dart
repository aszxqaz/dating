part of 'chats_bloc.dart';

class ChatsState {
  const ChatsState({required this.chats});

  static const initial = ChatsState(chats: []);

  final List<Chat> chats;

  ChatsState withNewChats(List<Chat> chats) {
    final newChats = [...chats, ...chats];
    return ChatsState(chats: newChats);
  }

  ChatsState withNewMessages(List<ChatMessage> messages) {
    var newChats = chats;

    for (final message in messages) {
      final index = newChats.indexWhere((chat) => chat.id == message.chatId);

      late Chat newChat;

      if (index == -1) {
        // newChat = Chat(
        //   id: message.chatId,
        //   messages: [message],
        //   partner: message.receiverId == globalUser!.id
        //       ? message.senderId
        //       : message.receiverId,
        // );
        throw Exception('not found index');
      } else {
        newChat = newChats[index].withNewMessages([message]);
      }

      newChats =
          newChats.slice(0, index) + [newChat] + newChats.slice(index + 1);
    }

    return ChatsState(chats: newChats);
  }

  ChatsState withoutMessage(String chatId, String messageId) {
    final index = chats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) return this;

    final newChat = chats[index].withoutMessage(messageId);
    final newChats = chats.slice(0, index) + [newChat] + chats.slice(index + 1);

    return ChatsState(chats: newChats);
  }

  ChatsState withoutChat(String chatId) {
    final index = chats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) return this;

    final newChats = chats.slice(0, index) + chats.slice(index + 1);

    return ChatsState(chats: newChats);
  }

  ChatsState withMessagesReadStatus(
      String chatId, List<String> messageIds, bool read) {
    final index = chats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) return this;

    final newChat = chats[index].withReadMessagesStatus(messageIds, read);
    final newChats = chats.slice(0, index) + [newChat] + chats.slice(index + 1);

    return ChatsState(chats: newChats);
  }

  bool includesPartner(String partnerId) =>
      chats.any((chat) => chat.partner.userId == partnerId);

  bool includesChat(String chatId) => chats.any((chat) => chat.id == chatId);

  Chat? getChatById(String chatId) =>
      chats.firstWhereOrNull((chat) => chat.id == chatId);

  List<ChatMessage> getMessagesByChatId(String chatId) {
    final chat = chats.firstWhereOrNull((chat) => chat.id == chatId);
    if (chat == null) {
      debugPrint(
          'ERROR: getMessagesByChatId() not found chat with id: $chatId');
      return [];
    }
    return chat.messages;
  }

  int get unreadCount => chats.fold(
        0,
        (sum, chat) =>
            sum +
            chat.messages.fold(
              0,
              (sum, message) =>
                  sum +
                  (!message.read && message.receiverId == globalUser!.id
                      ? 1
                      : 0),
            ),
      );

  Chat? getChatByPartnerId(String partnerId) =>
      chats.firstWhereOrNull((chat) => chat.partner.userId == partnerId);
}
