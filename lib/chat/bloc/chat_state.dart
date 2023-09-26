part of 'chat_bloc.dart';

class ChatState {
  const ChatState({
    this.chat,
    required this.profile,
  });

  final Chat? chat;
  final Profile profile;

  ChatState copyWith({Chat? chat, Profile? profile}) => ChatState(
        chat: chat ?? this.chat,
        profile: profile ?? this.profile,
      );
}

class ChatMessageExt {
  const ChatMessageExt({
    required this.message,
    this.loading = false,
  });

  final ChatMessage message;
  final bool loading;

  // factory ChatMessageExt.loaded(ChatMessage message) => ChatMessageExt(
  //       message: message,
  //       sent: true,
  //     );

  // factory ChatMessageExt.unloaded(ChatMessage message) => ChatMessageExt(
  //       message: message,
  //       sent: false,
  //     );

  ChatMessageExt copyWith({
    ChatMessage? message,
    bool? loading,
    bool? unread,
  }) =>
      ChatMessageExt(
        message: message ?? this.message,
        loading: loading ?? this.loading,
      );
}

class ChatExt {
  ChatExt({
    String? id,
    required this.messages,
    required this.partner,
  }) : id = id ?? uuid.v4();

  final String id;
  final List<ChatMessageExt> messages;
  final Profile partner;

  ChatExt withMessagesAdded(List<ChatMessageExt> newMessages) => ChatExt(
        id: id,
        partner: partner,
        messages: [...messages, ...newMessages],
      );

  bool get containsUnread => messages.any((m) => !m.message.read);

  ChatExt copyWith({
    String? id,
    List<ChatMessageExt>? messages,
    Profile? partner,
  }) =>
      ChatExt(
        id: id ?? this.id,
        messages: messages ?? this.messages,
        partner: partner ?? this.partner,
      );
}
