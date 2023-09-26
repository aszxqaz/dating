import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/models/chat.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';

part 'chats_new_state.dart';
part 'chats_new_event.dart';

class ChatsNewBloc extends Bloc<_ChatsNewEvent, ChatsNewState> {
  ChatsNewBloc() : super(const ChatsNewState(chats: [])) {
    // --- SEND MESSAGE
    on<_ChatsMessageSent>(_onChatsMessageSent);

    // --- RECEIVE MESSAGES
    on<_ChatsMessagesReceived>(_onChatsMessagesReceived);

    // --- INITIAL LOAD
    on<_ChatsMessagesLoadRequested>(_onChatsMessagesLoadRequested);

    // --- SUBSCRIPTION
    on<_ChatsMessagesSubscriptionRequested>(
        _onChatsMessagesSubscriptionRequested);

    // --- READ UNREAD MESSAGES
    on<_ChatsMessagesReadUnread>(_onChatMessagesReadUnread);

    add(const _ChatsMessagesLoadRequested());
  }

  StreamSubscription<List<ChatMessageNew>>? _incomingMessagesSubscription;

  @override
  Future<void> close() async {
    super.close();
    _incomingMessagesSubscription?.cancel();
  }

  // --- SEND CHAT MESSAGE
  FutureOr<void> _onChatsMessageSent(
    _ChatsMessageSent event,
    Emitter<ChatsNewState> emit,
  ) async {
    final draft = ChatMessageNew(
      read: false,
      receiverId: event.partnerId,
      senderId: globalUser!.id,
      text: event.text,
      incoming: false,
    );

    emit(state.upsertMessages([draft]));

    final message = await supabaseService.sendTextMessageNew(draft);

    if (message != null) {
      emit(state.upsertMessages([message]));
    } else {
      emit(state.withoutMessage(event.partnerId, draft.id));
    }
  }

  // --- MESSAGES RECEIVED
  void _onChatsMessagesReceived(
    _ChatsMessagesReceived event,
    Emitter<ChatsNewState> emit,
  ) {
    emit(state.upsertMessages(event.messages));
  }

  // --- FETCH INITIAL CHATS
  FutureOr<void> _onChatsMessagesLoadRequested(
    _ChatsMessagesLoadRequested event,
    Emitter<ChatsNewState> emit,
  ) async {
    final chats = await supabaseService.getChats();

    if (chats != null) {
      emit(ChatsNewState(chats: chats));
    }
  }

  // --- INCOMING MESSAGES SUBSCRIPTION
  FutureOr<void> _onChatsMessagesSubscriptionRequested(
    _ChatsMessagesSubscriptionRequested event,
    Emitter<ChatsNewState> emit,
  ) async {
    _incomingMessagesSubscription =
        supabaseService.subscribeReceiverMessagesNew(
      onData: (messages) {
        add(_ChatsMessagesReceived(messages: messages));
      },
    );
  }

  // --- READ UNREAD MESSAGES
  FutureOr<void> _onChatMessagesReadUnread(
    _ChatsMessagesReadUnread event,
    Emitter<ChatsNewState> emit,
  ) async {
    final partnerId = event.partnerId;
    final messageIds = state.messageIdsUnreadIncoming(partnerId);

    emit(state.withMessagesReadStatus(partnerId, messageIds, true));

    if (!await supabaseService.readUnreadMessagesNew(messageIds)) {
      emit(state.withMessagesReadStatus(partnerId, messageIds, false));
    }
  }

  // --------------
  // --------------
  // --- PUBLIC API
  void sendChatMessage(String partnerId, String text) {
    add(_ChatsMessageSent(partnerId: partnerId, text: text));
  }

  void readUnreadChatMessages(String partnerId) {
    add(_ChatsMessagesReadUnread(partnerId: partnerId));
  }
}
