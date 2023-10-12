import 'package:collection/collection.dart';
import 'package:dating/chat/emoji_text_field.dart';
import 'package:dating/common/online_label.dart';
import 'package:dating/common/route_transition.dart';
import 'package:dating/common/wrapper_builder.dart';
import 'package:dating/features/chat/chats_bloc.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/misc/datetime_ext.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

part 'chat_message_scrollview.dart';
part 'chat_message_widget.dart';
part 'chat_route.dart';
part '_wrapper_builder.dart';

class ChatView extends HookWidget {
  const ChatView({
    super.key,
    required this.partnerId,
  });

  static route({
    required BuildContext context,
    required String partnerId,
    bool slide = false,
  }) {
    final create = slide ? createRouteSlideTransition : createRoute;
    return create(
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
      ),
    );
  }

  final String partnerId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatsBloc, ChatsState>(
      listener: (context, state) {
        final chat = state.getChatByPartnerId(partnerId);
        if (chat != null) {
          if (chat.containsUnread) {
            ChatsBloc.of(context).readUnreadChatMessages(partnerId);
          }
        }
      },
      child: WrapperBuilder2(
        appBar: _buildAppBar(),
        builder: (context, constraints) {
          return BlocSelector<ChatsBloc, ChatsState, Chat?>(
            selector: (state) => state.getChatByPartnerId(partnerId),
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
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  color: Colors.white.withOpacity(1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black45,
                        )
                      ],
                    ),
                    child: EmojiTextField(
                      onMessageSendPressed: (text) async {
                        context
                            .read<ChatsBloc>()
                            .sendChatMessage(partnerId, text);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: BlocSelector<ProfilesBloc, ProfilesState, Profile?>(
          selector: (state) => state.getProfile(partnerId),
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
          }),
    );
  }
}
