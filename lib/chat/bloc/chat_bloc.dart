import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating/misc/uuid.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';

part 'chat_state.dart';
part 'chat_event.dart';

class ChatBloc extends Bloc<_ChatEvent, ChatState> {
  ChatBloc({required Profile profile, Chat? chat})
      : super(ChatState(profile: profile, chat: chat)) {
    // --- SUBSCRIPTION
    on<_MessagesSubscribed>((event, emit) {
      if (state.chat == null) return;
    });

    // --- SEND MESSAGE
    on<_MessageSent>((event, emit) async {
      if (state.chat == null) return;
      final chat = state.chat!;

      // final message = ChatMessage(id: id, chatId: chat.id, senderId: senderId, receiverId: receiverId, text: event.text,);

      // emit(state.copyWith(chat: state.chat!.withMessagesAdded([newMessages])))
      // final result = await supabaseService.sendTextMessage(
      //   state.profile.userId,
      //   event.text,
      // );
    });

    // --- RECEIVE MESSAGES
    on<_MessagesReceived>((event, emit) async {
      debugPrint('New messages received');
      // emit(state.copyWith(chat: state.chat!.withMessagesAdded(event.messages)));
    });

    _subscribeToIncomingMessages();
  }

  late StreamSubscription<Iterable<ChatMessage>>? _subscription;

  @override
  close() async {
    super.close();
    _subscription?.cancel();
  }

  Future<void> sendMessage(String text) async {
    add(_MessageSent(text: text));
  }

  _subscribeToIncomingMessages() {
    if (state.chat != null) {
      _subscription = supabaseService.subscribeReceiverMessages(
        onData: (messages) {
          add(_MessagesReceived(
              messages: messages
                  .where((message) => state.chat != null
                      ? !state.chat!.messages
                          .any((message2) => message2.id == message.id)
                      : true)
                  .toList()));
        },
      );
    }
  }
}
