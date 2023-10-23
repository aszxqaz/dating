part of 'app_bloc.dart';

enum UnauthenticatedTab { signin, signup }

@immutable
sealed class AppState {
  const AppState();
}

final class AppUnauthenticatedState extends AppState {
  const AppUnauthenticatedState({
    this.tab = UnauthenticatedTab.signin,
    required this.countryCode,
  });

  static const initial = AppUnauthenticatedState(
    tab: UnauthenticatedTab.signin,
    countryCode: null,
  );

  final UnauthenticatedTab tab;
  final String? countryCode;

  AppUnauthenticatedState copyWith({
    UnauthenticatedTab? tab,
    String? countryCode,
  }) =>
      AppUnauthenticatedState(
        tab: tab ?? this.tab,
        countryCode: countryCode ?? this.countryCode,
      );
}

final class AppAuthenticatedState extends AppState {
  const AppAuthenticatedState({required this.profile});

  final Profile profile;
}

final class AppIncompletedState extends AppState {
  const AppIncompletedState();
}

final class AppLoadingState extends AppState {
  const AppLoadingState();
}
