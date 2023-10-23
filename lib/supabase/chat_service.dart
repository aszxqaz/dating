part of 'service.dart';

mixin _ChatService on _BaseSupabaseService {
  // ---
  // --- FETCH ALL CHATS
  // ---
  Future<List<Chat>?> fetchChats() async {
    return tryExecute('[ChatService.fetchChats]', () async {
      var messagesJson = await supabaseClient
          .from('chat_messages')
          .select<PostgrestList>()
          .or('sender_id.eq.$requireUserId,receiver_id.eq.$requireUserId');

      debugPrint('$messagesJson');

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

  Future<ChatMessage?> sendChatMessage({
    required ChatMessage message,
    void Function(String photoId)? onPhotoLoaded,
  }) async {
    return tryExecute('[ChatService] sendChatMessage()', () async {
      if (requireUserId == message.receiverId) return null;

      Map<String, String> photoUrls = {};

      if (message.photos != null) {
        await Future.wait(
          message.photos!.map((photo) async {
            final response = await uploadBinaryPhoto(photo.bytes!);
            onPhotoLoaded?.call(photo.id);
            photoUrls[photo.id] = response!.url;
          }),
        );
      }

      if (photoUrls.isEmpty && message.text?.isNotEmpty == false) {
        return null;
      }

      // debugPrint(message.photo)

      final json = await supabaseClient
          .from('chat_messages')
          .insert({
            'id': message.id,
            'sender_id': requireUserId,
            'receiver_id': message.receiverId,
            'text': message.text,
            'photos_json': message.photos
                ?.map((photo) => photo.copyWith(
                      url: photoUrls[photo.id],
                    ))
                .map((photo) => photo.toJson())
                .toList(),
          })
          .select<Map<String, dynamic>>('created_at')
          .single();

      return message.copyWith(createdAt: DateTime.tryParse(json['created_at']));
    });
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
