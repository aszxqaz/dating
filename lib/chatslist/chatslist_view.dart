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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

part '_item.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({
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
