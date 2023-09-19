part of 'home_bloc.dart';

enum HomeTabs {
  feed,
  notifications,
  slides,
  messages,
  user;

  static HomeTabs initial = HomeTabs.slides;

  static HomeTabs fromJson(int index) {
    switch (index) {
      case 0:
        return HomeTabs.feed;
      case 1:
        return HomeTabs.notifications;
      case 2:
        return HomeTabs.slides;
      case 3:
        return HomeTabs.messages;
      case 4:
        return HomeTabs.user;
      default:
        return HomeTabs.initial;
    }
  }
}

@immutable
final class HomeState {
  const HomeState({
    required this.tab,
    required this.location,
  });

  final HomeTabs tab;
  final UserLocation location;

  static const initial = HomeState(
    tab: HomeTabs.user,
    location: UserLocation.empty,
  );

  HomeState copyWith({HomeTabs? tab, UserLocation? location}) => HomeState(
        tab: tab ?? this.tab,
        location: location ?? this.location,
      );
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

  int toJson() => index;
}
