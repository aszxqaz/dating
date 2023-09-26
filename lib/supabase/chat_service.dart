part of 'service.dart';

mixin _ChatService on _BaseSupabaseService {
  static const chatSelect = '''
            id,
            creator:creator_id (
              *,
              photos (
                *, photo_likes (
                  *
                )
              ),
              locations (*),
              preferences (*)
            ),
            subject:subject_id (
              *,
              photos (
                *, photo_likes (
                  *
                )
              ),
              locations (*),
              preferences (*)
            )
          ''';

  Future<List<Chat>?> findChats() async {
    final id = globalUser?.id;
    if (id == null) return null;

    // --- CHATS
    final List chatslist = await supabaseClient
        .from('chats')
        .select(chatSelect)
        .or('creator_id.eq.$id,subject_id.eq.$id');

    // debugPrint('findChats() chatslist: ${chatslist.toPrettyJson()}');

    // --- MESSAGES
    final List messageslist = await supabaseClient
        .from('chat_messages')
        .select()
        .in_('chat_id', chatslist.map((chat) => chat['id']).toList());

    // debugPrint('findChats() messageslist: ${messageslist.toPrettyJson()}');

    // --- COMBINE
    final chats = chatslist
        .mapIndexed(
          (index, chatJson) => Chat(
            id: chatJson['id'] as String,
            partner: Profile.fromJson(
              chatJson['creator']['user_id'] == id
                  ? chatJson['subject']
                  : chatJson['creator'],
            ),
            messages: messageslist
                .where(
                  (message) => message['chat_id'] == chatJson['id'],
                )
                .map((messageJson) => ChatMessage.fromJson(messageJson))
                .toList(),
          ),
        )
        .toList();

    return chats;
  }

  Future<List<ChatNew>?> getChats() async {
    final userId = globalUser?.id;
    if (userId == null) return null;

    try {
      final messagesJson = await supabaseClient
          .from('chat_messages_new')
          .select<List<Map<String, dynamic>>>()
          .or('sender_id.eq.$userId,receiver_id.eq.$userId');

      debugPrint('FETCHED CHATS: ${messagesJson.toString()}');

      final messages = messagesJson.map(
        (json) => ChatMessageNew.fromJson(
          json,
          incoming: json['sender_id'] != userId,
        ),
      );

      final grouped = messages.groupListsBy(
        (message) =>
            message.senderId == userId ? message.receiverId : message.senderId,
      );

      final chats = grouped.entries
          .map(
            (group) => ChatNew(
              partnerId: group.key,
              messages: group.value,
            ),
          )
          .toList();
      return chats;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<ChatMessageNew?> sendTextMessageNew(ChatMessageNew draft) async {
    final userId = globalUser?.id;
    if (userId == null || userId == draft.receiverId) return null;

    try {
      final json = await supabaseClient
          .from('chat_messages_new')
          .insert({
            'id': draft.id,
            'sender_id': userId,
            'receiver_id': draft.receiverId,
            'text': draft.text,
          })
          .select<Map<String, dynamic>>()
          .single();

      final message = ChatMessageNew.fromJson(json, incoming: false);
      return message;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> sendTextMessage(SendTextMessageArgs args) async {
    final userId = globalUser?.id;
    debugPrint('sendTextMessage() userId: $userId');
    debugPrint('sendTextMessage() receiverId: ${args.receiverId}');

    if (userId == null || userId == args.receiverId) return false;

    try {
      if (args.createChat) {
        await supabaseClient.from('chats').insert({
          'id': args.chatId,
          'creator_id': userId,
          'subject_id': args.receiverId,
        });
      }

      // Map<String, dynamic>? chat = await supabaseClient
      //     .from('chats')
      //     .select()
      //     .in_('creator_id', [userId, args.receiverId]).in_(
      //         'subject_id', [userId, args.receiverId]).maybeSingle();

      // chat ??= await supabaseClient
      //     .from('chats')
      //     .insert({
      //       'id': args.chatId,
      //       'creator_id': userId,
      //       'subject_id': args.receiverId,
      //     })
      //     .select()
      //     .maybeSingle();

      // await supabaseClient
      //     .from('chats')
      //     .insert({
      //       'id': args.chatId,
      //       'creator_id': userId,
      //       'subject_id': args.receiverId,
      //     })
      //     .select()
      //     .maybeSingle();

      await supabaseClient.from('chat_messages').insert({
        'chat_id': args.chatId,
        'sender_id': userId,
        'receiver_id': args.receiverId,
        'text': args.text,
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    return true;

    // Map<String, dynamic>? chat = await supabaseClient
    //     .from('chats')
    //     .select()
    //     .in_('creator_id', [userId, message.receiverId]).in_(
    //         'subject_id', [userId, message.receiverId]).maybeSingle();
    // debugPrint('sendTextMessage() chat: ${chat.toString()}');

    // chat ??= await supabaseClient
    //     .from('chats')
    //     .insert({
    //       'id': message.id,
    //       'creator_id': userId,
    //       'subject_id': message.receiverId,
    //     })
    //     .select()
    //     .maybeSingle();
    // debugPrint('sendTextMessage() chat: ${chat.toString()}');
  }

  StreamSubscription<List<ChatMessage>> subscribeMessages({
    required String chatId,
    required void Function(List<ChatMessage> messages) onData,
  }) {
    final userId = globalUser?.id;

    return supabaseClient
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .map((list) => list.map((json) => ChatMessage.fromJson(json)).toList())
        .listen(onData);
  }

  StreamSubscription<List<ChatMessage>> subscribeReceiverMessages({
    required void Function(List<ChatMessage> messages) onData,
  }) {
    final userId = globalUser?.id;

    return supabaseClient
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('receiver_id', userId)
        .map((list) => list.map((json) => ChatMessage.fromJson(json)).toList())
        .listen(onData);
  }

  StreamSubscription<List<ChatMessageNew>> subscribeReceiverMessagesNew({
    required void Function(List<ChatMessageNew> messages) onData,
  }) {
    final userId = globalUser?.id;

    return supabaseClient
        .from('chat_messages_new')
        .stream(primaryKey: ['id'])
        .eq('receiver_id', userId)
        .map((list) => list
            .map((json) => ChatMessageNew.fromJson(
                  json,
                  incoming: json['sender_id'] != userId,
                ))
            .toList())
        .listen(onData);
  }

  Future<bool> readUnreadMessages(List<String> messageIds) async {
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

  Future<bool> readUnreadMessagesNew(List<String> messageIds) async {
    try {
      await supabaseClient
          .from('chat_messages_new')
          .update({'read': true}).in_('id', messageIds);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }
}

class SendTextMessageArgs {
  const SendTextMessageArgs({
    required this.chatId,
    required this.receiverId,
    required this.text,
    this.createChat = false,
  });

  final String chatId;
  final String receiverId;
  final String text;
  final bool createChat;
}
