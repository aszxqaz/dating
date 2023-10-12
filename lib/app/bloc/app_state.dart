part of 'app_bloc.dart';

enum UnauthenticatedTabs { signin, signup }

@immutable
sealed class AppState {
  const AppState();
}

final class AppUnauthenticatedState extends AppState {
  const AppUnauthenticatedState({required this.tab});

  static const initial =
      AppUnauthenticatedState(tab: UnauthenticatedTabs.signin);

  final UnauthenticatedTabs tab;
}

final class AppAuthenticatedState extends AppState {
  const AppAuthenticatedState({required this.profile});

  final Profile profile;
}

final class AppLoadingState extends AppState {
  const AppLoadingState();
}

final class AppIncompleteState extends AppState {
  const AppIncompleteState({this.countryCode});
  final String? countryCode;
}
