part of 'photo_uploader_bloc.dart';

sealed class _PhotoUploaderEvent {
  const _PhotoUploaderEvent();
}

class _AddFiles extends _PhotoUploaderEvent {
  const _AddFiles({required this.files});

  final List<XFile> files;
}

class _ItemsProcessed extends _PhotoUploaderEvent {
  const _ItemsProcessed({required this.itemId});

  final String itemId;
}

class _ProcessSingle extends _PhotoUploaderEvent {
  const _ProcessSingle({required this.file});

  final XFile file;
}
