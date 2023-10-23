import 'package:collection/collection.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:dating/features/features.dart';
import 'package:dating/misc/datetime_ext.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/profile/profile_view.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '_feed_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocSelector<FeedBloc, FeedState, List<FeedChannelModel>>(
                selector: (state) => state.feeds,
                builder: (context, feeds) {
                  return feeds.isNotEmpty
                      ? Column(
                          children: feeds.map((feed) {
                            return BlocSelector<ProfilesBloc, ProfilesState,
                                Profile?>(
                              selector: (profilesState) =>
                                  profilesState.getProfile(feed.senderId),
                              builder: (context, sender) {
                                if (sender == null) {
                                  return const Text('Loading...');
                                }

                                final photo = sender.photos.firstWhereOrNull(
                                    (photo) => photo.id == feed.photoId);

                                return _PhotoFeedCard(
                                  profile: sender,
                                  photo: photo,
                                  feed: feed,
                                );
                              },
                            );
                          }).toList(),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
