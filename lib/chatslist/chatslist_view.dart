import 'package:collection/collection.dart';
import 'package:dating/assets/icons.dart';
import 'package:dating/chat/chat_view.dart';
import 'package:dating/common/online_label.dart';
import 'package:dating/features/features.dart';
import 'package:dating/misc/datetime_ext.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsList extends HookWidget {
  const ChatsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatsBloc, ChatsState, List<Chat>>(
      selector: (state) => state.chats,
      builder: (context, chats) {
        final sorted = chats
            .whereNot((chat) => chat.messages.isEmpty)
            .sortedBy((chat) => chat.lastMessage.createdAt)
            .reversed;

        return chats.isNotEmpty
            ? ListView(
                children: (sorted)
                    .map((chat) => _ChatListViewItem(chat: chat))
                    .toList(),
              )
            : Center(
                child: Column(
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      IconAssets.loveLetterBig,
                      width: 120,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.primary.withAlpha(200),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No messages yet.\nWrite somebody.',
                      style: context.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              );
      },
    );
  }
}

class _ChatListViewItem extends StatelessWidget {
  const _ChatListViewItem({
    required this.chat,
  });

  final Chat chat;
  static const double itemHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: chat.containsUnread ? Colors.blue.shade50 : null,
      shape: const Border(
        bottom: BorderSide(
          color: Color.fromRGBO(45, 93, 101, 0.3),
        ),
      ),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            ChatView.route(
              context: context,
              partnerId: chat.partnerId,
              slide: true,
            ),
          );
        },
        child: BlocSelector<ProfilesBloc, ProfilesState, Profile?>(
          selector: (state) => state.getProfile(chat.partnerId),
          builder: (context, partner) {
            return Row(
              children: [
                ProfilePhoto(
                  partner?.avatarUrl,
                  size: const Size.square(itemHeight),
                ),
                Expanded(
                  child: SizedBox(
                    height: itemHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              partner != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          partner.name,
                                          style: context.textTheme.titleLarge,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (partner.isOnline) ...[
                                          const SizedBox(width: 8),
                                          const OnlineLabel(),
                                        ]
                                      ],
                                    )
                                  : const Text('Loading...'),
                              Text(
                                chat.lastMessage.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Text(chat.lastMessage.createdAt.shortStringDateTime),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
