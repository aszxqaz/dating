part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

final class HomeTabChanged extends HomeEvent {
  const HomeTabChanged({required this.tab});
  final HomeTabs tab;
}
