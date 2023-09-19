part of 'user_bloc.dart';

sealed class UserEvent {
  const UserEvent();
}

final class LoadPhotosUserEvent extends UserEvent {
  const LoadPhotosUserEvent();
}
