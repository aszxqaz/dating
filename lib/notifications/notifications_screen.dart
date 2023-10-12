import 'package:dating/features/notifications/notifications_bloc.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/misc/datetime_ext.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:dating/profile/profile_view.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/supabase/models/notification.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void didChangeDependencies() {
    context.read<NotificationsBloc>().readUnread();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsBloc, NotificationsState>(
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            context.read<NotificationsBloc>().readUnread();
          }
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<NotificationsBloc, NotificationsState>(
                  builder: (context, state) {
                    return BlocSelector<UserBloc, UserState, List<Photo>>(
                      selector: (state) => state.profile!.photos,
                      builder: (context, photos) {
                        return Column(
                          children: state.likes
                              .map(
                                (like) => BlocSelector<ProfilesBloc,
                                    ProfilesState, Profile?>(
                                  selector: (profilesState) =>
                                      profilesState.getProfile(like.senderId),
                                  builder: (context, sender) {
                                    if (sender == null) {
                                      return const Text('Loading...');
                                    }

                                    final photo = photos.firstWhere(
                                        (photo) => photo.id == like.photoId);

                                    return _LikeNotificationCard(
                                      profile: sender,
                                      photo: photo,
                                      like: like,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LikeNotificationCard extends StatelessWidget {
  const _LikeNotificationCard({
    required this.profile,
    required this.photo,
    required this.like,
  });

  final Profile profile;
  final Photo photo;
  final LikeNotification like;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
      margin: const EdgeInsets.only(bottom: 8),
      height: 80,
      decoration: BoxDecoration(
        color: like.read ? Colors.white : Colors.lightBlue.shade200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 1,
          ),
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            ProfilePage.route(
              context: context,
              profileId: profile.userId,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ProfilePhoto(
                  profile.avatarUrl,
                  size: const Size.square(56),
                  circle: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text('Liked your photo'),
                    ],
                  ),
                ),
                Material(
                  elevation: 2,
                  child: ProfilePhoto(
                    photo.url,
                    size: const Size.square(42),
                  ),
                ),
                const SizedBox(width: 12),
                Text(like.createdAt.shortStringDateTime),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
