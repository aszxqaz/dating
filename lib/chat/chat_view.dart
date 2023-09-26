// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dating/assets/icons.dart';
import 'package:dating/chat/emoji_text_field.dart';
import 'package:dating/chatslist/bloc/chats_bloc.dart';
import 'package:dating/features/chat/chats_new_bloc.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/models/chat.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'chat_message_widget.dart';
part 'chat_message_scrollview.dart';

class ChatView extends HookWidget {
  const ChatView({
    super.key,
    required this.partnerId,
  });

  static route({
    required BuildContext context,
    required String partnerId,
  }) =>
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<ChatsNewBloc>(
              create: (_) => context.read<ChatsNewBloc>(),
            ),
            BlocProvider<ProfilesBloc>(
              create: (_) => context.read<ProfilesBloc>(),
            ),
          ],
          child: ChatView(partnerId: partnerId),
        ),
      );

  final String partnerId;

  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   if (chat != null) {
    //     context.read<ChatsBloc>().readUnreadChatMessages(chat!.id);
    //   }
    // }, []);

    return BlocSelector<ProfilesBloc, ProfilesState, Profile?>(
      selector: (state) => state.getProfile(partnerId),
      builder: (context, partner) {
        return BlocListener<ChatsNewBloc, ChatsNewState>(
          listener: (context, state) {
            final chat = state.getChatByPartnerId(partnerId);
            if (chat != null) {
              if (chat.containsUnread) {
                context.read<ChatsNewBloc>().readUnreadChatMessages(partnerId);
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  partner == null
                      ? Container(
                          width: 20,
                          height: 20,
                          color: context.colorScheme.primaryContainer
                              .withOpacity(0.7),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : partner.hasAvatar
                          ? CircleAvatar(
                              foregroundImage: NetworkImage(partner.avatarUrl!),
                              radius: 20,
                            )
                          : Container(
                              width: 20,
                              height: 20,
                              color: context.colorScheme.primaryContainer
                                  .withOpacity(0.7),
                              child: SvgPicture.asset(
                                IconAssets.userPlaceholder,
                                colorFilter: ColorFilter.mode(
                                  context.colorScheme.primary.withOpacity(0.2),
                                  BlendMode.srcIn,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                  const SizedBox(width: 10),
                  partner == null
                      ? const Text('Loading...')
                      : Text(partner.name),
                ],
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: BlocSelector<ChatsNewBloc, ChatsNewState, ChatNew?>(
                    selector: (state) => state.getChatByPartnerId(partnerId),
                    builder: (context, chat) {
                      final messages = chat?.messages ?? [];

                      return Column(
                        children: [
                          Expanded(
                            child: _MessagesScrollView(messages: messages),
                          ),
                          EmojiTextField(
                            onMessageSendPressed: (text) async {
                              context
                                  .read<ChatsNewBloc>()
                                  .sendChatMessage(partnerId, text);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
