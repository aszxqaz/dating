import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chats_state.dart';
part 'chats_event.dart';

class ChatsBloc extends Bloc<_ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsState.empty) {
    // --- SEND MESSAGE
    on<_MessageSent>(_onChatsMessageSent);

    // --- RECEIVE MESSAGES
    on<_MessagesReceived>(_onChatsMessagesReceived);

    // --- INITIAL LOAD
    on<_FetchChats>(_onFetchAll);

    // --- SUBSCRIPTION
    on<_SubscriptionRequested>(_onSubscriptionsRequested);

    // --- READ UNREAD MESSAGES
    on<_ReadUnread>(_onReadUnread);
  }

  static ChatsBloc of(BuildContext context) => context.read<ChatsBloc>();

  FutureVoidCallback? _unsubscribeReceiver;
  FutureVoidCallback? _unsubscribeSender;

  @override
  close() async {
    super.close();
    await _unsubscribeReceiver?.call();
    await _unsubscribeSender?.call();
  }

  // ---
  // --- SEND CHAT MESSAGE
  // ---
  FutureOr<void> _onChatsMessageSent(
    _MessageSent event,
    Emitter<ChatsState> emit,
  ) async {
    final draft = ChatMessage(
      read: false,
      receiverId: event.partnerId,
      senderId: globalUser!.id,
      text: event.text,
      incoming: false,
      sent: false,
      createdAt: DateTime.now(),
    );

    emit(state.upsertMessages([draft]));

    final message = await supabaseService.sendTextMessageNew(draft);

    if (message != null) {
      emit(state.upsertMessages([message]));
    } else {
      emit(state.withoutMessage(event.partnerId, draft.id));
    }
  }

  // ---
  // --- MESSAGES RECEIVED
  // ---
  void _onChatsMessagesReceived(
    _MessagesReceived event,
    Emitter<ChatsState> emit,
  ) {
    debugPrint('Messages received: length: ${event.messages.length}');

    emit(state.upsertMessages(event.messages));
  }

  // ---
  // --- FETCH INITIAL CHATS
  // ---
  FutureOr<void> _onFetchAll(
    _FetchChats event,
    Emitter<ChatsState> emit,
  ) async {
    final chats = await supabaseService.fetchChats();

    if (chats != null) {
      emit(ChatsState(chats: chats, last: chats));
    }
  }

  // ---
  // --- MESSAGES SUBSCRIPTION
  // ---
  FutureOr<void> _onSubscriptionsRequested(
    _SubscriptionRequested event,
    Emitter<ChatsState> emit,
  ) async {
    _unsubscribeReceiver = await supabaseService.subscribeReceiverMessage(
      onData: (message) {
        add(_MessagesReceived(messages: [message]));
      },
    );

    _unsubscribeSender = await supabaseService.subscribeSenderMessage(
      onData: (message) {
        add(_MessagesReceived(messages: [message]));
      },
    );
  }

  // ---
  // --- READ UNREAD MESSAGES
  // ---
  FutureOr<void> _onReadUnread(
    _ReadUnread event,
    Emitter<ChatsState> emit,
  ) async {
    final partnerId = event.partnerId;
    final messageIds = state.messageIdsUnreadIncoming(partnerId);

    if (messageIds.isEmpty) return;

    emit(state.withMessagesReadStatus(partnerId, messageIds, true));

    if (!await supabaseService.readUnreadMessagesNew(messageIds)) {
      emit(state.withMessagesReadStatus(partnerId, messageIds, false));
    }
  }

  // ---
  // --- PUBLIC API
  // ---
  void fetchChats() {
    add(const _FetchChats());
  }

  void requestSubscription() {
    add(const _SubscriptionRequested());
  }

  void sendChatMessage(String partnerId, String text) {
    text = text.trim();
    if (text.isEmpty) return;
    add(_MessageSent(partnerId: partnerId, text: text));
  }

  void readUnreadChatMessages(String partnerId) {
    add(_ReadUnread(partnerId: partnerId));
  }
}
