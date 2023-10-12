import 'package:animations/animations.dart';
import 'package:dating/app/app.dart';
import 'package:dating/chatslist/chatslist_view.dart';
import 'package:dating/common/switcher.dart';
import 'package:dating/features/features.dart';
import 'package:dating/home/bloc/home_bloc.dart';
import 'package:dating/hot_cards/hot_cards.dart';
import 'package:dating/hot_swipe/view/hot_swipe_view.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/notifications/notifications_screen.dart';
import 'package:dating/user/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class _HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<HomeBloc>().requestLocationSubscription();

      return null;
    }, []);

    return BlocBuilder<HomeBloc, HomeState>(
      // buildWhen: (p, c) => p.tab != c.tab,
      builder: (context, state) {
        return Scaffold(
          appBar: appBars.contains(state.tab)
              ? AppBar(
                  title: Text(state.tab.text),
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
              : null,
          bottomNavigationBar: const _HomeBottomNavigationBar(),
          body: PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: pagesMap[state.tab],
          ),
        );
      },
    );
  }
}

const pagesMap = {
  HomeTabs.feed: Text('Feed'),
  HomeTabs.notifications: NotificationsScreen(),
  HomeTabs.search: HotCardsScreen(),
  HomeTabs.slides: HotSwipeScreen(),
  HomeTabs.messages: ChatsList(),
  HomeTabs.user: UserScreen(),
};

const appBars = [
  HomeTabs.user,
  HomeTabs.messages,
  HomeTabs.notifications,
];

class _SlidesPage extends StatelessWidget {
  const _SlidesPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconSwitcher(
        notifier: IconSwitcherChangeNotifier(),
      ),
    );
  }
}
