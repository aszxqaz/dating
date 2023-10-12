part of 'user_bloc.dart';

class UserState {
  const UserState({
    this.loading = false,
    this.error,
    required this.profile,
    this.curPhotoIndex = 0,
  });

  // static const initialLoading = UserState(loading: true);

  final bool loading;
  final String? error;
  final Profile profile;
  final int curPhotoIndex;

  List<String>? get links => profile.photos.map((p) => p.url).toList();

  Photo? get currentPhoto =>
      profile.hasPhotos ? profile.photos[curPhotoIndex] : null;

  UserState copyWith({
    bool? loading,
    String? error,
    Profile? profile,
    int? curPhotoIndex,
  }) =>
      UserState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        profile: profile ?? this.profile,
        curPhotoIndex: curPhotoIndex ?? this.curPhotoIndex,
      );

  UserState excludePhoto() {
    // ignore: no_leading_underscores_for_local_identifiers
    var _photos = profile.photos;

    _photos =
        _photos.slice(0, curPhotoIndex) + _photos.slice(curPhotoIndex + 1);

    return copyWith(profile: profile.copyWith(photos: _photos));
  }
}
