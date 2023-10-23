part of 'user_bloc.dart';

sealed class _UserEvent {
  const _UserEvent();
}

final class _LoadPhotos extends _UserEvent {
  const _LoadPhotos();
}

final class _FetchUserProfile extends _UserEvent {
  const _FetchUserProfile();
}

final class _ChangePrefs extends _UserEvent {
  const _ChangePrefs({
    required this.name,
    required this.value,
  });

  final String name;
  final int value;
}

final class _UploadPhoto extends _UserEvent {
  const _UploadPhoto({required this.bytes});

  final Uint8List bytes;
}

final class _DeletePhoto extends _UserEvent {
  const _DeletePhoto();
}

final class _QuoteUpdated extends _UserEvent {
  const _QuoteUpdated({required this.quote});

  final String quote;
}
