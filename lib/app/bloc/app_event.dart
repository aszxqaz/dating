part of 'app_bloc.dart';

@immutable
sealed class _AppEvent {
  const _AppEvent();
}

final class _Authenticated extends _AppEvent {
  const _Authenticated({required this.profile});

  final Profile profile;
}

final class _Incompleted extends _AppEvent {
  const _Incompleted();
}

final class _Unauthenticated extends _AppEvent {
  const _Unauthenticated({required this.countryCode});

  final String? countryCode;
}

final class AppAuthStateChanged extends _AppEvent {
  const AppAuthStateChanged({required this.event});

  final AuthChangeEvent event;
}

final class _SubmitIncomplete extends _AppEvent {
  const _SubmitIncomplete({required this.name, required this.birthdate});

  final String name;
  final DateTime birthdate;
}

final class AppStateChanged extends _AppEvent {
  const AppStateChanged({required this.state});

  final AppState state;
}
