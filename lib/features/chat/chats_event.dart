part of 'chats_bloc.dart';

sealed class _ChatsEvent {
  const _ChatsEvent();
}

final class _SubscriptionRequested extends _ChatsEvent {
  const _SubscriptionRequested();
}

final class _FetchChats extends _ChatsEvent {
  const _FetchChats();
}

final class _ReadUnread extends _ChatsEvent {
  const _ReadUnread({
    required this.partnerId,
  });

  final String partnerId;
}

final class _MessageSent extends _ChatsEvent {
  const _MessageSent({
    required this.partnerId,
    required this.text,
  });

  final String partnerId;
  final String text;
}

final class _MessagesReceived extends _ChatsEvent {
  const _MessagesReceived({required this.messages});

  final List<ChatMessage> messages;
}
