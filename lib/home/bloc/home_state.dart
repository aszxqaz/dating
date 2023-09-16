part of 'home_bloc.dart';

enum HomeTabs { feed, notifications, slides, messages, user }

@immutable
final class HomeState {
  const HomeState({required this.tab});
  final HomeTabs tab;

  factory HomeState.initial() => const HomeState(tab: HomeTabs.user);
}

extension HomeTabsDisplay on HomeTabs {
  String get text {
    switch (this) {
      case HomeTabs.feed:
        return 'Feed';
      case HomeTabs.notifications:
        return 'Notifications';
      case HomeTabs.slides:
        return 'Hot';
      case HomeTabs.messages:
        return 'Messages';
      case HomeTabs.user:
        return 'My Profile';
    }
  }
}
