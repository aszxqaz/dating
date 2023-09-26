part of 'chats_new_bloc.dart';

sealed class _ChatsNewEvent {
  const _ChatsNewEvent();
}

final class _ChatsMessagesSubscriptionRequested extends _ChatsNewEvent {
  const _ChatsMessagesSubscriptionRequested();
}

final class _ChatsMessagesLoadRequested extends _ChatsNewEvent {
  const _ChatsMessagesLoadRequested();
}

final class _ChatsMessagesReadUnread extends _ChatsNewEvent {
  const _ChatsMessagesReadUnread({
    required this.partnerId,
  });

  final String partnerId;
}

final class _ChatsMessageSent extends _ChatsNewEvent {
  const _ChatsMessageSent({
    required this.partnerId,
    required this.text,
  });

  final String partnerId;
  final String text;
}

final class _ChatsMessagesReceived extends _ChatsNewEvent {
  const _ChatsMessagesReceived({required this.messages});

  final List<ChatMessageNew> messages;
}
