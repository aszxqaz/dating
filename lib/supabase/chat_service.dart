part of 'service.dart';

mixin _ChatService on _BaseSupabaseService {
  // ---
  // --- FETCH ALL CHATS
  // ---
  Future<List<Chat>?> fetchChats() async {
    return tryExecute('fetchChats', () async {
      final messagesJson = await supabaseClient
          .from('chat_messages')
          .select<List<Map<String, dynamic>>>()
          .or('sender_id.eq.$requireUserId,receiver_id.eq.$requireUserId');

      final messages = messagesJson.map(
        (json) => ChatMessage.fromJson(
          json,
          incoming: json['sender_id'] != requireUserId,
        ),
      );

      final grouped = messages.groupListsBy(
        (message) => message.senderId == requireUserId
            ? message.receiverId
            : message.senderId,
      );

      final chats = grouped.entries
          .map(
            (group) => Chat(
              partnerId: group.key,
              messages: group.value,
            ),
          )
          .toList();
      return chats;
    });
  }

  Future<ChatMessage?> sendTextMessageNew(ChatMessage draft) async {
    final userId = globalUser?.id;
    if (userId == null || userId == draft.receiverId) return null;

    try {
      final json = await supabaseClient
          .from('chat_messages')
          .insert({
            'id': draft.id,
            'sender_id': userId,
            'receiver_id': draft.receiverId,
            'text': draft.text,
          })
          .select<Map<String, dynamic>>()
          .single();

      final message = ChatMessage.fromJson(json, incoming: false);
      return message;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// ---
  /// --- SUBSCRIBE MESSAGES AS A RECEIVER
  /// ---
  FutureOr<FutureVoidCallback?> subscribeReceiverMessage({
    required void Function(ChatMessage message) onData,
  }) {
    final filter = 'receiver_id=eq.$requireUserId';

    return tryExecute('subscribeReceiverMessage', () async {
      final channel = createChannel('chat_messages:receiver').on_(
        table: 'chat_messages',
        filter: filter,
        event: 'INSERT',
        onData: (json) {
          final like = ChatMessage.fromJson(json, incoming: true);
          onData(like);
        },
      );

      channel.subscribe();

      return () async {
        await channel.unsubscribe();
      };
    });
  }

  /// ---
  /// --- SUBSCRIBE MESSAGES AS A SENDER
  /// ---
  FutureOr<FutureVoidCallback?> subscribeSenderMessage({
    required void Function(ChatMessage message) onData,
  }) {
    final filter = 'sender_id=eq.$requireUserId';

    return tryExecute('subscribeSenderMessage', () async {
      final channel = createChannel('chat_messages:sender')
        ..on_(
          table: 'chat_messages',
          filter: filter,
          event: 'INSERT',
          onData: (json) {
            final like = ChatMessage.fromJson(json, incoming: false);
            onData(like);
          },
        )
        ..on_(
          table: 'chat_messages',
          filter: filter,
          event: 'UPDATE',
          onData: (json) {
            final like = ChatMessage.fromJson(json, incoming: false);
            onData(like);
          },
        );

      channel.subscribe();

      return () async {
        await channel.unsubscribe();
      };
    });
  }

  Future<bool> readUnreadMessagesNew(List<String> messageIds) async {
    try {
      await supabaseClient
          .from('chat_messages')
          .update({'read': true}).in_('id', messageIds);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }
}
