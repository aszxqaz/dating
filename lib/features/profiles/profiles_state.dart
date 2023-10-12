part of 'profiles_bloc.dart';

enum LoadingStatus { loading, failure, loaded }

typedef LoadingStatusMap = Map<String, LoadingStatus>;

final class ProfilesState {
  const ProfilesState({
    this.profiles = const [],
    this.last = const [],
    this.loading = LoadingStatus.loading,
    this.statuses = const {},
  });

  final List<Profile> profiles;
  final List<Profile> last;
  final LoadingStatusMap statuses;
  final LoadingStatus loading;

  // ---
  // --- UPDATE LOADING STATUS
  // ---
  ProfilesState updateLoadingStatus(String profileId, LoadingStatus status) =>
      copyWith(statuses: {
        ...statuses,
        profileId: status,
      });

  // ---
  // --- UPSERT PROFILES
  // ---
  ProfilesState upsertProfiles(List<Profile> fetched) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _profiles = profiles;
    // ignore: no_leading_underscores_for_local_identifiers
    List<Profile> _last = [];

    for (final profile in fetched) {
      final index = indexById(profile.userId);
      if (index != -1) {
        _profiles =
            _profiles.slice(0, index) + [profile] + _profiles.slice(index + 1);
      } else {
        _profiles = [..._profiles, profile];
        _last += [profile];
      }
    }

    return copyWith(profiles: _profiles, last: _last);
  }

  ProfilesState copyWith({
    List<Profile>? profiles,
    List<Profile>? last,
    LoadingStatus? loading,
    LoadingStatusMap? statuses,
  }) =>
      ProfilesState(
        profiles: profiles ?? this.profiles,
        loading: loading ?? this.loading,
        statuses: statuses ?? this.statuses,
        last: last ?? this.last,
      );

  Profile? getProfile(String id) =>
      profiles.firstWhereOrNull((profile) => profile.userId == id);

  int indexById(String id) =>
      profiles.indexWhere((profile) => profile.userId == id);
}
