part of 'chats_bloc.dart';

sealed class ChatsEvent {
  const ChatsEvent();
}

class ChatsMessagesSubscriptionRequested extends ChatsEvent {
  const ChatsMessagesSubscriptionRequested();
}

class ChatsMessagesLoadRequested extends ChatsEvent {
  const ChatsMessagesLoadRequested();
}

class ChatsMessagesReadUnread extends ChatsEvent {
  const ChatsMessagesReadUnread({required this.chatId});

  final String chatId;
}

class ChatsMessageSent extends ChatsEvent {
  const ChatsMessageSent({
    required this.chat,
    required this.partner,
    required this.text,
  });

  final Chat? chat;
  final Profile partner;
  final String text;
}

class ChatsMessagesReceived extends ChatsEvent {
  const ChatsMessagesReceived({required this.messages});

  final List<ChatMessage> messages;
}
