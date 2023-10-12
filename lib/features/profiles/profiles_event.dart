part of 'profiles_bloc.dart';

sealed class _ProfilesEvent {
  const _ProfilesEvent();
}

final class _FetchCardsProfiles extends _ProfilesEvent {
  const _FetchCardsProfiles();
}

final class _FetchProfile extends _ProfilesEvent {
  const _FetchProfile({required this.profileId});

  final String profileId;
}

final class _FetchProfiles extends _ProfilesEvent {
  const _FetchProfiles({required this.profileIds});

  final List<String> profileIds;
}

final class _LikePhoto extends _ProfilesEvent {
  const _LikePhoto({
    required this.profileId,
    required this.photoId,
  });

  final String profileId;
  final String photoId;
}
