import 'package:dating/assets/icons.dart';
import 'package:dating/chat/chat_view.dart';
import 'package:dating/features/features.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/models/chat.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsListNew extends HookWidget {
  const ChatsListNew({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsNewBloc, ChatsNewState>(
      builder: (context, state) {
        return ListView(
          children: (state.chats)
              .map((chat) => _ChatListViewItem(chat: chat))
              .toList(),
        );
      },
    );
  }
}

class _ChatListViewItem extends StatelessWidget {
  const _ChatListViewItem({
    super.key,
    required this.chat,
  });

  final ChatNew chat;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1),
      color: chat.containsUnread ? Colors.yellow.shade100 : null,
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            ChatView.route(
              context: context,
              partnerId: chat.partnerId,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocSelector<ProfilesBloc, ProfilesState, Profile?>(
            selector: (state) => state.getProfile(chat.partnerId),
            builder: (context, partner) {
              return Row(
                children: [
                  partner == null
                      ? const Text('Loading...')
                      : partner.hasAvatar
                          ? CircleAvatar(
                              foregroundImage:
                                  NetworkImage(partner.photos.first.url),
                              radius: 32,
                            )
                          : Container(
                              width: 64,
                              height: 64,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colorScheme.primaryContainer
                                    .withOpacity(0.7),
                              ),
                              child: SvgPicture.asset(
                                IconAssets.userPlaceholder,
                                colorFilter: ColorFilter.mode(
                                  context.colorScheme.primary.withOpacity(0.2),
                                  BlendMode.srcIn,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        partner != null
                            ? Text(
                                partner.name,
                                style: context.textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text('Loading...'),
                        const SizedBox(height: 12),
                        Text(
                          chat.messages.last.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
