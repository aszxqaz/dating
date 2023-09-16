part of 'app_bloc.dart';

enum UnauthenticatedTabs { signin, signup }

@immutable
sealed class AppState {
  const AppState();
}

final class AppUnauthenticatedState extends AppState {
  const AppUnauthenticatedState({required this.tab});

  factory AppUnauthenticatedState.initial() =>
      const AppUnauthenticatedState(tab: UnauthenticatedTabs.signin);

  final UnauthenticatedTabs tab;
}

final class AppAuthenticatedState extends AppState {
  const AppAuthenticatedState();
}
