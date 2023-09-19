part of 'hot_bloc.dart';

class HotState {
  const HotState({
    this.loading = false,
    this.error,
    this.profiles = const [],
  });

  static const initialLoading = HotState(loading: true);

  final bool loading;
  final String? error;

  final Iterable<Profile> profiles;

  Iterable<HotCard> get cards => profiles.map(HotCard.fromProfile);

  HotState copyWith({
    bool? loading,
    String? error,
    Iterable<Profile>? profiles,
  }) =>
      HotState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        profiles: profiles ?? this.profiles,
      );
}
