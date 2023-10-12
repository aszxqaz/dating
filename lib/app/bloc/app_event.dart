part of 'app_bloc.dart';

@immutable
sealed class AppEvent {
  const AppEvent();
}

final class AppAuthenticatedEvent extends AppEvent {
  const AppAuthenticatedEvent();
}

final class AppUnauthenticatedEvent extends AppEvent {
  const AppUnauthenticatedEvent();
}

final class AppUnauthenticatedTabChanged extends AppEvent {
  const AppUnauthenticatedTabChanged({required this.tab});

  final UnauthenticatedTabs tab;
}

final class AppAuthStateChanged extends AppEvent {
  const AppAuthStateChanged({required this.event});

  final AuthChangeEvent event;
}

final class AppSubmitIncomplete extends AppEvent {
  const AppSubmitIncomplete({required this.name, required this.birthdate});

  final String name;
  final DateTime birthdate;
}
