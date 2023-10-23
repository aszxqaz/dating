import 'dart:async';
import 'dart:math';

import 'package:blurhash/blurhash.dart';
import 'package:collection/collection.dart';
import 'package:dating/chat/photo_uploader_bloc/photo_uploader_bloc.dart';
import 'package:dating/interfaces/identifiable.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';

part 'chats_state.dart';
part 'chats_event.dart';

class ChatsBloc extends Bloc<_ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsState.empty) {
    on<_MessageSent>(_onChatsMessageSent);
    on<_MessagesReceived>(_onChatsMessagesReceived);
    on<_FetchChats>(_onFetchAll);
    on<_Subscribed>(_onSubscribed);
    // on<_Unsubscribed>(_onUnsubscribed);
    on<_ReadUnread>(_onReadUnread);
  }

  static ChatsBloc of(BuildContext context) => context.read<ChatsBloc>();

  FutureVoidCallback? _unsubscribeReceiver;
  FutureVoidCallback? _unsubscribeSender;

  // ---
  // --- SEND CHAT MESSAGE
  // ---
  FutureOr<void> _onChatsMessageSent(
    _MessageSent event,
    Emitter<ChatsState> emit,
  ) async {
    final message = ChatMessage(
      receiverId: event.partnerId,
      senderId: globalUser!.id,
      text: event.text,
      photos: event.photos?.map(ChatMessagePhoto.fromUpload).toList(),
    );

    emit(state.upsertMessages([message]));

    final messageId = message.id;

    final response = await supabaseService.sendChatMessage(
        message: message,
        onPhotoLoaded: (id) {
          final chat = state.getChatByPartnerId(event.partnerId);

          if (chat == null) return;

          final message = chat.getChatMessage(messageId)!;
          final photos = message.photos!;
          final photo = photos.get(id)!;

          emit(state.upsertMessages(
              [message.copyWith(photos: photos.update(photo.uploaded))]));
        });

    if (response != null) {
      final chat = state.getChatByPartnerId(event.partnerId);

      if (chat == null) return;

      final message = chat.getChatMessage(messageId)!;
      emit(state
          .upsertMessages([message.copyWith(createdAt: response.createdAt)]));
    } else {
      emit(state.withoutMessage(event.partnerId, message.id));
    }
  }

  // ---
  // --- MESSAGES RECEIVED
  // ---
  void _onChatsMessagesReceived(
    _MessagesReceived event,
    Emitter<ChatsState> emit,
  ) {
    // emit(state.upsertMessages(event.messages));
  }

  // ---
  // --- FETCH INITIAL CHATS
  // ---
  FutureOr<void> _onFetchAll(
    _FetchChats event,
    Emitter<ChatsState> emit,
  ) async {
    var chats = await supabaseService.fetchChats();

    if (chats == null) return;

    List<dynamic> saved = [];
    final a = [2];

    var now = DateTime.now();

    // await Future.wait(chats.map((chat) async {
    //   return Future.wait(chat.messages.map((message) async {
    //     if (message.photos != null) {
    //       final count = max(message.photos!.length, 9);

    //       return Future.wait(message.photos!.map((photo) async {
    //         final baseWidth = count % 3 == 0
    //             ? 50
    //             : count % 2 == 0
    //                 ? 65
    //                 : 100;

    //         final blurHash = await BlurHash.decode(
    //           photo.blurHash,
    //           baseWidth,
    //           (photo.height / photo.width * baseWidth).round(),
    //         );

    //         if (blurHash != null) {
    //           saved.add({
    //             'photoId': photo.id,
    //             'messageId': message.id,
    //             'partnerId': chat.partnerId,
    //             'blurHash': blurHash,
    //           });
    //         }
    //       }));
    //     }
    //   }));
    // }));

    // final after = DateTime.now();

    // debugPrint(
    //     'BLUR HASHES CALCED IN ${after.difference(now).inMilliseconds} MS');

    // while (saved.isNotEmpty) {
    //   final entry = saved.removeLast();

    //   var chat =
    //       chats!.firstWhere((chat) => chat.partnerId == entry['partnerId']);

    //   var message = chat.messages
    //       .firstWhere((message) => message.id == entry['messageId']);

    //   var photo =
    //       message.photos!.firstWhere((photo) => photo.id == entry['photoId']);

    //   photo = photo.copyWith(blurBytes: entry['blurHash']);

    //   message = message.copyWith(photos: message.photos!.update(photo));

    //   chat = chat.copyWith(messages: chat.messages.update(message));

    //   chats = chats.update(chat);
    // }

    // debugPrint(
    //     'CHATS UPDATED IN ${DateTime.now().difference(after).inMilliseconds} MS');

    emit(ChatsState(chats: chats!, last: chats));
  }

  // ---
  // --- SUBSCRIPTION
  // ---
  FutureOr<void> _onSubscribed(
    _Subscribed event,
    Emitter<ChatsState> emit,
  ) async {
    _unsubscribeReceiver = await supabaseService.subscribeReceiverMessage(
      onData: (message) {
        add(_MessagesReceived(messages: [message]));
      },
    );

    debugPrint('[ChatsBloc] receiver subscribed');

    _unsubscribeSender = await supabaseService.subscribeSenderMessage(
      onData: (message) {
        add(_MessagesReceived(messages: [message]));
      },
    );

    debugPrint('[ChatsBloc] sender subscribed');
  }

  // // ---
  // // --- UNSUBSCRIBE
  // // ---
  // FutureOr<void> _onUnsubscribed(
  //   _Unsubscribed event,
  //   Emitter<ChatsState> emit,
  // ) async {
  //   await _unsubscribeReceiver?.call();
  //   await _unsubscribeSender?.call();
  // }

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

  void subscribe() {
    add(const _Subscribed());
  }

  void unsubscribe() {
    _unsubscribeReceiver?.call();
    debugPrint(
        '[ChatsBloc] messages receiver subscription cancellation requested');

    _unsubscribeSender?.call();
    debugPrint(
        '[ChatsBloc] messages sender subscription cancellation requested');
  }

  void sendChatMessage(
    String partnerId,
    String text,
    List<PhotoUploaderItem>? photos,
  ) {
    add(_MessageSent(
      partnerId: partnerId,
      text: text,
      photos: photos,
    ));
  }

  void readUnreadChatMessages(String partnerId) {
    add(_ReadUnread(partnerId: partnerId));
  }
}
