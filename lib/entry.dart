import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/app/app.dart';
import 'package:dating/auth/auth_page.dart';
import 'package:dating/features/features.dart';
import 'package:dating/home/bloc/home_bloc.dart';
import 'package:dating/home/home_page.dart';
import 'package:dating/incomplete/incomplete_page.dart';
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
        BlocProvider(
          create: (_) => FeedBloc(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // ---
          // --- AUTHENTICATED
          // ---
          BlocListener<AppBloc, AppState>(
            listenWhen: (previous, current) =>
                previous is! AppAuthenticatedState &&
                current is AppAuthenticatedState,
            listener: (context, _) {
              ChatsBloc.of(context).subscribe();
              HomeBloc.of(context).subscribe();
              NotificationsBloc.of(context).subscribe();
              ProfilesBloc.of(context).fetchCardsProfiles();
              NotificationsBloc.of(context).fetchLikeNotifications();
              ChatsBloc.of(context).fetchChats();
            },
          ),

          // ---
          // --- UNAUTHENTICATED
          // ---
          BlocListener<AppBloc, AppState>(
            listenWhen: (previous, current) =>
                previous is AppAuthenticatedState &&
                current is! AppAuthenticatedState,
            listener: (context, _) {
              NotificationsBloc.of(context).unsubscribe();
              ChatsBloc.of(context).unsubscribe();
              HomeBloc.of(context).unsubscribe();
            },
          ),

          // ---
          // --- CACHE NEW PROFILES PHOTOS
          // ---
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

          // ---
          // --- FETCH PROFILES ON NOTIFICATIONS RECEIVED
          // ---
          BlocListener<NotificationsBloc, NotificationsState>(
            listenWhen: (previous, current) => previous.last != current.last,
            listener: (context, state) {
              final profileIds = state.last
                  .map((notification) => notification.senderId)
                  .toList();

              ProfilesBloc.of(context).fetchProfiles(profileIds);
            },
          ),

          // ---
          // --- FETCH PROFILES ON CHATS RECEIVED
          // ---
          BlocListener<ChatsBloc, ChatsState>(
            listenWhen: (previous, current) => previous.last != current.last,
            listener: (context, state) {
              final profileIds =
                  state.last.map((chat) => chat.partnerId).toList();

              ProfilesBloc.of(context).fetchProfiles(profileIds);
            },
          ),

          // ---
          // --- FETCH PROFILES ON FEEDS RECEIVED
          // ---
          BlocListener<FeedBloc, FeedState>(
            listenWhen: (previous, current) => previous.last != current.last,
            listener: (context, state) {
              final profileIds =
                  state.last.map((feed) => feed.senderId).toList();

              ProfilesBloc.of(context).fetchProfiles(profileIds);
            },
          ),

          // ---
          // --- FETCH AND SUBSCRIBE FEED ON FEED TAB OPENED
          // ---
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              switch (state.tab) {
                case HomeTab.feed:
                  FeedBloc.of(context).fetchFeed();
                  FeedBloc.of(context).subscribe();

                default:
              }
            },
          ),

          // ---
          // --- UNSUBSCRIBE ON FEED TAB CLOSED
          // ---
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) =>
                previous.tab == HomeTab.feed && current.tab != HomeTab.feed,
            listener: (context, _) => FeedBloc.of(context).unsubscribe(),
          ),
        ],
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            switch (state) {
              case AppLoadingState _:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              /// --- AUTHENTICATED AND COMPLETE
              case AppAuthenticatedState state:
                final profile = state.profile;

                return BlocProvider(
                  create: (context) => UserBloc(profile: profile),
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

              case AppIncompletedState _:
                return const IncompletePage();

              case AppUnauthenticatedState state:
                return AuthPage(countryCode: state.countryCode);
            }
          },
        ),
      ),
    );
  }
}
