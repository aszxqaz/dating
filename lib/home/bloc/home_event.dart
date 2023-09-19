part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

final class HomeTabChanged extends HomeEvent {
  const HomeTabChanged({required this.tab});
  final HomeTabs tab;
}

final class LocationRequested extends HomeEvent {
  const LocationRequested();
}

final class LocationChanged extends HomeEvent {
  const LocationChanged(this.location);

  final UserLocation location;
}

final class LocationSubscriptionStarted extends HomeEvent {
  const LocationSubscriptionStarted();
}

final class LocationSubscriptionEnded extends HomeEvent {
  const LocationSubscriptionEnded();
}
