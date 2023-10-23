import 'package:dating/features/notifications/notifications_bloc.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/misc/datetime_ext.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:dating/profile/profile_view.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '_like_card.dart';

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
                      selector: (state) => state.profile.photos,
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
