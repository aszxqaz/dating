part of 'chatslist_view.dart';

class _ChatListViewItem extends StatelessWidget {
  const _ChatListViewItem({
    required this.chat,
  });

  final Chat chat;
  static const double itemHeight = 80;

  @override
  Widget build(BuildContext context) {
    final hasText = chat.lastMessage.text?.isNotEmpty == true;
    final hasSinglePhoto = chat.lastMessage.photos?.length == 1;
    final hasManyPhotos = (chat.lastMessage.photos?.length ?? 0) > 1;

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
                          Expanded(
                            child: Column(
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
                                Builder(
                                  builder: (context) {
                                    if (hasText) {
                                      return Text(
                                        chat.lastMessage.text ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }

                                    if (hasSinglePhoto) {
                                      return const Icon(
                                        Ionicons.image_outline,
                                        size: 20,
                                      );
                                    }

                                    if (hasManyPhotos) {
                                      return const Icon(
                                        Ionicons.images_outline,
                                        size: 20,
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
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
