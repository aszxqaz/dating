import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dating/chat/photo_uploader_bloc/photo_uploader_bloc.dart';
import 'package:dating/common/common.dart';
import 'package:dating/common/online_label.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:dating/common/route_transition.dart';
import 'package:dating/common/spinning_animated_icon.dart';
import 'package:dating/common/stripes_background.dart';
import 'package:dating/common/wrapper_builder.dart';
import 'package:dating/features/chat/chats_bloc.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/helpers/pick_photo.dart';
import 'package:dating/misc/datetime_ext.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart' as flutterBlurHash;
import 'package:ionicons/ionicons.dart';
import 'package:transparent_image/transparent_image.dart';

part 'bottom_controls/_button.dart';
part 'bottom_controls/_main_panel.dart';
part 'bottom_controls/_photo_uploader.dart';
part 'bottom_controls/_text_field.dart';
part 'bottom_controls/bottom_controls.dart';
part 'chat_message/_chat_message_widget.dart';
part 'chat_message/_message_meta_info.dart';
part 'chat_message/_photo_message.dart';
part 'chat_message/_text_message.dart';
part 'chat_message_scrollview.dart';
part 'chat_route.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.partnerId,
  });

  static Widget routeWidget({
    required BuildContext context,
    required String partnerId,
  }) =>
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: BlocProvider.of<ChatsBloc>(context),
          ),
          BlocProvider.value(
            value: BlocProvider.of<ProfilesBloc>(context),
          ),
        ],
        child: ChatView(partnerId: partnerId),
      );

  static route({
    required BuildContext context,
    required String partnerId,
    bool slide = false,
  }) {
    final create = slide ? createRouteSlideTransition : createRoute;
    return create(routeWidget(context: context, partnerId: partnerId));
  }

  final String partnerId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void didChangeDependencies() {
    ChatsBloc.of(context).readUnreadChatMessages(widget.partnerId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhotoUploaderBloc>(
      create: (context) => PhotoUploaderBloc(context),
      child: BlocListener<ChatsBloc, ChatsState>(
        listener: (context, state) {
          final chat = state.getChatByPartnerId(widget.partnerId);
          if (chat != null) {
            if (chat.containsUnread) {
              ChatsBloc.of(context).readUnreadChatMessages(widget.partnerId);
            }
          }
        },
        child: WrapperBuilder2(
          appBar: _buildAppBar(),
          builder: (context, constraints) {
            return BlocSelector<ChatsBloc, ChatsState, Chat?>(
              selector: (state) => state.getChatByPartnerId(widget.partnerId),
              builder: (context, chat) {
                final messages = chat?.messages ?? [];

                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          _MessagesScrollView(
                            messages: messages,
                          ),
                        ],
                      ),
                    ),
                    _BottomControls(
                      onMessageSendPressed: (text, photos) async {
                        if (photos?.any((el) => el.status.isProcessing) ==
                            true) {
                          return;
                        }
                        ChatsBloc.of(context).sendChatMessage(
                          widget.partnerId,
                          text,
                          photos,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: BlocSelector<ProfilesBloc, ProfilesState, Profile?>(
        selector: (state) => state.getProfile(widget.partnerId),
        builder: (context, partner) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfilePhoto(
                partner?.avatarUrl,
                size: const Size.square(36),
                circle: true,
              ),
              const SizedBox(width: 10),
              partner == null ? const Text('Loading...') : Text(partner.name),
              if (partner?.isOnline == true) ...[
                const SizedBox(width: 8),
                const OnlineLabel(),
              ]
            ],
          );
        },
      ),
    );
  }
}
