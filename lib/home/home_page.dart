import 'package:dating/app/app.dart';
import 'package:dating/chatslist/chatslist_view.dart';
import 'package:dating/common/animations.dart';
import 'package:dating/features/features.dart';
import 'package:dating/feed/feed_screen.dart';
import 'package:dating/home/bloc/home_bloc.dart';
import 'package:dating/hot_cards/hot_cards.dart';
import 'package:dating/hot_swipe/view/hot_swipe_view.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/notifications/notifications_screen.dart';
import 'package:dating/user/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

part '_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HotCardsBloc(),
      child: _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  AppBar? _buildAppBar(HomeTab tab, BuildContext context) {
    return !_appBarExcluded.contains(tab)
        ? AppBar(
            title: Text(tab.text),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Ionicons.settings_outline),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: context.read<AppBloc>().signOut,
                icon: const Icon(Ionicons.exit_outline),
              ),
            ],
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, HomeTab>(
      selector: (state) => state.tab,
      builder: (context, tab) {
        return Scaffold(
          appBar: _buildAppBar(tab, context),
          bottomNavigationBar: const _HomeBottomNavigationBar(),
          body: _HomeBody(tab: tab),
        );
      },
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.tab});

  final HomeTab tab;

  @override
  Widget build(BuildContext context) {
    return FadeThroughSwitcherBuilder(
      builder: (context) {
        switch (tab) {
          case HomeTab.feed:
            return const FeedScreen();
          case HomeTab.notifications:
            return const NotificationsScreen();
          case HomeTab.search:
            return const HotCardsScreen();
          case HomeTab.slides:
            return const HotSwipeScreen();
          case HomeTab.messages:
            return const ChatsListScreen();
          case HomeTab.user:
            return const UserScreen();
        }
      },
    );
  }
}

const _appBarExcluded = [
  HomeTab.slides,
  HomeTab.search,
];
