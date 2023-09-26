part of 'chat_bloc.dart';

sealed class _ChatEvent {
  const _ChatEvent();
}

class _MessagesSubscribed extends _ChatEvent {
  const _MessagesSubscribed();
}

class _MessageSent extends _ChatEvent {
  const _MessageSent({required this.text});

  final String text;
}

class _MessagesReceived extends _ChatEvent {
  const _MessagesReceived({required this.messages});

  final List<ChatMessage> messages;
}
