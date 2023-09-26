import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';

part 'chats_state.dart';
part 'chats_event.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(const ChatsState(chats: [])) {
    // --- SEND MESSAGE
    on<ChatsMessageSent>(_onChatsMessageSent);

    // --- RECEIVE MESSAGES
    on<ChatsMessagesReceived>(_onChatsMessagesReceived);

    // --- INITIAL LOAD
    on<ChatsMessagesLoadRequested>(_onChatsMessagesLoadRequested);

    // --- SUBSCRIPTION
    on<ChatsMessagesSubscriptionRequested>(
        _onChatsMessagesSubscriptionRequested);

    // --- READ UNREAD MESSAGES
    on<ChatsMessagesReadUnread>(_onChatMessagesReadUnread);

    add(const ChatsMessagesLoadRequested());
  }

  late StreamSubscription<List<ChatMessage>>? _incomingMessagesSubscription;

  @override
  Future<void> close() async {
    _incomingMessagesSubscription?.cancel();
    super.close();
  }

  void loadChats() async {}

  FutureOr<void> _onChatsMessageSent(
    ChatsMessageSent event,
    Emitter<ChatsState> emit,
  ) async {
    bool createChat = false;

    var chat = state.getChatByPartnerId(event.partner.userId);

    if (chat == null) {
      createChat = true;
      chat = Chat(partner: event.partner, messages: []);
    }

    final args = SendTextMessageArgs(
      chatId: chat.id,
      receiverId: chat.partner.userId,
      text: event.text,
      createChat: event.chat != null ? false : true,
    );

    final message = ChatMessage(
      chatId: args.chatId,
      read: false,
      receiverId: args.receiverId,
      senderId: globalUser!.id,
      text: args.text,
    );

    if (createChat) {
      chat = chat.withNewMessages([message]);
      emit(state.withNewChats([chat]));
    } else {
      emit(state.withNewMessages([message]));
    }

    if (!await supabaseService.sendTextMessage(args)) {
      if (createChat) {
        emit(state.withoutChat(args.chatId));
      } else {
        emit(state.withoutMessage(args.chatId, message.id));
      }
    }
  }

  FutureOr<void> _onChatsMessagesReceived(
    ChatsMessagesReceived event,
    Emitter<ChatsState> emit,
  ) async {
    debugPrint('New messages received');

    final groups = event.messages.groupListsBy((message) => message.chatId);
    final chats = <Chat>[];

    for (final entry in groups.entries) {
      final chatId = entry.key;
      final messages = entry.value;

      if (!state.includesChat(chatId)) {
        final profile =
            await supabaseService.findProfileByUserId(messages.first.senderId);
        if (profile == null) {
          debugPrint('ERROR: did not find partner for chatId: $chatId');
          continue;
        }
        chats.add(Chat(id: chatId, partner: profile, messages: messages));
      }
    }

    final filtered = event.messages
        .where((message) => groups.keys.contains(message.chatId))
        .toList();

    emit(state.withNewMessages(filtered).withNewChats(chats));
  }

  FutureOr<void> _onChatsMessagesLoadRequested(
    ChatsMessagesLoadRequested event,
    Emitter<ChatsState> emit,
  ) async {
    final chats = await supabaseService.findChats();

    if (chats != null) {
      emit(ChatsState(chats: chats));
    }
  }

  FutureOr<void> _onChatsMessagesSubscriptionRequested(
    ChatsMessagesSubscriptionRequested event,
    Emitter<ChatsState> emit,
  ) async {
    _incomingMessagesSubscription = supabaseService.subscribeReceiverMessages(
      onData: (messages) {
        add(ChatsMessagesReceived(messages: messages));
      },
    );
  }

  FutureOr<void> _onChatMessagesReadUnread(
    ChatsMessagesReadUnread event,
    Emitter<ChatsState> emit,
  ) async {
    final messageIds =
        state.getMessagesByChatId(event.chatId).map((m) => m.id).toList();
    emit(state.withMessagesReadStatus(event.chatId, messageIds, true));
    if (!await supabaseService.readUnreadMessages(messageIds)) {
      emit(state.withMessagesReadStatus(event.chatId, messageIds, false));
    }
  }

  void readUnreadChatMessages(String chatId) {
    add(ChatsMessagesReadUnread(chatId: chatId));
  }
}
