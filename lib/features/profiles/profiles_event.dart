part of 'profiles_bloc.dart';

sealed class _ProfilesEvent {
  const _ProfilesEvent();
}

final class _LoadAll extends _ProfilesEvent {
  const _LoadAll();
}

final class _LoadCertain extends _ProfilesEvent {
  const _LoadCertain({required this.profileId});

  final String profileId;
}
