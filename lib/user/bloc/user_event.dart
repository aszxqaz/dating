part of 'user_bloc.dart';

sealed class UserEvent {
  const UserEvent();
}

final class LoadPhotosUserEvent extends UserEvent {
  const LoadPhotosUserEvent();
}

final class LoadProfilesUserEvent extends UserEvent {
  const LoadProfilesUserEvent();
}

final class ChangePrefUserEvent extends UserEvent {
  const ChangePrefUserEvent({
    required this.name,
    required this.value,
  });

  final String name;
  final int? value;
}
