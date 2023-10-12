import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/app/app.dart';
import 'package:dating/common/animations.dart';
import 'package:dating/features/features.dart';
import 'package:dating/home/bloc/home_bloc.dart';
import 'package:dating/home/home_page.dart';
import 'package:dating/signin/view/signin_view.dart';
import 'package:dating/signup/signup.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppBloc(),
        ),
        BlocProvider(
          create: (_) => HomeBloc(),
        ),
        BlocProvider(
          create: (_) => ProfilesBloc(),
        ),
        BlocProvider(
          create: (_) => ChatsBloc(),
        ),
        BlocProvider(
          create: (_) => NotificationsBloc(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              if (state is AppAuthenticatedState) {
                ProfilesBloc.of(context).fetchCardsProfiles();
                NotificationsBloc.of(context).fetchLikeNotifications();
                NotificationsBloc.of(context).requestSubscription();
                ChatsBloc.of(context).fetchChats();
                ChatsBloc.of(context).requestSubscription();
                HomeBloc.of(context).requestLocationSubscription();
                HomeBloc.of(context).requestLastSeenSubscription();
              } else {}
            },
          ),
          BlocListener<ProfilesBloc, ProfilesState>(
            listenWhen: (previous, current) => previous.last != current.last,
            listener: (context, state) {
              for (final profile in state.last) {
                final imageProviders = profile.photoUrls
                    .map((url) => CachedNetworkImageProvider(url));
                for (final provider in imageProviders) {
                  precacheImage(provider, context);
                }
              }
            },
          ),
          BlocListener<NotificationsBloc, NotificationsState>(
            listenWhen: (previous, current) => previous.last != current.last,
            listener: (context, state) {
              final profileIds = state.last
                  .map((notification) => notification.senderId)
                  .toList();

              ProfilesBloc.of(context).fetchProfiles(profileIds);
            },
          ),
          BlocListener<ChatsBloc, ChatsState>(
            listenWhen: (previous, current) => previous.last != current.last,
            listener: (context, state) {
              final profileIds =
                  state.last.map((chat) => chat.partnerId).toList();

              ProfilesBloc.of(context).fetchProfiles(profileIds);
            },
          ),
        ],
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            switch (state) {
              case AppLoadingState _:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case AppIncompleteState _:
                return const Text('Incomplete');

              /// --- AUTHENTICATED AND COMPLETE
              case AppAuthenticatedState state:
                return BlocProvider(
                  create: (context) => UserBloc(profile: state.profile),
                  child: BlocListener<UserBloc, UserState>(
                    listenWhen: (previous, current) =>
                        previous.profile.photos.length !=
                        current.profile.photos.length,
                    listener: (context, state) {
                      final imageProviders = state.profile.photoUrls
                          .map((url) => CachedNetworkImageProvider(url));
                      for (final provider in imageProviders) {
                        precacheImage(provider, context);
                      }
                    },
                    child: const HomePage(),
                  ),
                );
              case AppUnauthenticatedState state:
                final page = switch (state.tab) {
                  UnauthenticatedTabs.signin => const SignInPage(),
                  UnauthenticatedTabs.signup => const SignUpPage()
                };

                return FadeThroughSwitcher(
                  child: page,
                );
            }
          },
        ),
      ),
    );
  }
}
