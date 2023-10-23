part of 'chats_bloc.dart';

sealed class _ChatsEvent {
  const _ChatsEvent();
}

final class _Subscribed extends _ChatsEvent {
  const _Subscribed();
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
    required this.photos,
  });

  final String partnerId;
  final String text;
  final List<PhotoUploaderItem>? photos;
}

final class _MessagesReceived extends _ChatsEvent {
  const _MessagesReceived({required this.messages});

  final List<ChatMessage> messages;
}

// final class _Unsubscribed extends _ChatsEvent {
//   const _Unsubscribed();
// }
