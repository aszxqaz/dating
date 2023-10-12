part of 'home_bloc.dart';

@immutable
sealed class _HomeEvent {
  const _HomeEvent();
}

final class _HomeTabChanged extends _HomeEvent {
  const _HomeTabChanged({required this.tab});
  final HomeTabs tab;
}

final class _LocationRequested extends _HomeEvent {
  const _LocationRequested();
}

final class _LocationChanged extends _HomeEvent {
  const _LocationChanged(this.location);

  final UserLocation location;
}

final class _LocationSubscriptionRequested extends _HomeEvent {
  const _LocationSubscriptionRequested();
}

final class _LastSeenSubscriptionRequested extends _HomeEvent {
  const _LastSeenSubscriptionRequested();
}

final class _LocationSubscriptionEnded extends _HomeEvent {
  const _LocationSubscriptionEnded();
}
