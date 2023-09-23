part of 'user_bloc.dart';

class UserState {
  const UserState({
    this.loading = false,
    this.error,
    this.photos,
    this.profile,
  });

  static const initialLoading = UserState(loading: true);

  final bool loading;
  final String? error;

  final List<PhotoTable>? photos;
  final Profile? profile;

  UserState copyWith({
    bool? loading,
    String? error,
    List<PhotoTable>? photos,
    Profile? profile,
  }) =>
      UserState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        photos: photos ?? this.photos,
        profile: profile ?? this.profile,
      );

  List<String>? get links => photos?.map((p) => p.link).toList();
}
