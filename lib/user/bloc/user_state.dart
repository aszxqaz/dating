part of 'user_bloc.dart';

class UserState {
  const UserState({
    this.loading = false,
    this.error,
    this.photos,
  });

  static const initialLoading = UserState(loading: true);

  final bool loading;
  final String? error;

  final List<PhotoTable>? photos;

  UserState copyWith({
    bool? loading,
    String? error,
    List<PhotoTable>? photos,
  }) =>
      UserState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        photos: photos ?? this.photos,
      );

  List<String>? get links => photos?.map((p) => p.link).toList();
}
