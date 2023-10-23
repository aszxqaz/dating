part of 'home_bloc.dart';

enum HomeTab {
  feed,
  notifications,
  slides,
  messages,
  search,
  user;

  static HomeTab initial = HomeTab.slides;
}

@immutable
final class HomeState {
  const HomeState({
    required this.tab,
    required this.location,
  });

  final HomeTab tab;
  final UserLocation location;

  static const initial = HomeState(
    tab: HomeTab.slides,
    location: UserLocation.empty,
  );

  HomeState copyWith({HomeTab? tab, UserLocation? location}) => HomeState(
        tab: tab ?? this.tab,
        location: location ?? this.location,
      );
}

extension HomeTabsDisplay on HomeTab {
  String get text {
    switch (this) {
      case HomeTab.feed:
        return 'Feed';
      case HomeTab.notifications:
        return 'Notifications';
      case HomeTab.slides:
        return 'Hot';
      case HomeTab.messages:
        return 'Messages';
      case HomeTab.user:
        return 'My Profile';
      case HomeTab.search:
        return 'Search';
    }
  }
}
