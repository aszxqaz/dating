part of 'photo_uploader_bloc.dart';

class PhotoUploaderState {
  const PhotoUploaderState({required this.items});

  final List<PhotoUploaderItem> items;

  PhotoUploaderState copyWith({List<PhotoUploaderItem>? items}) =>
      PhotoUploaderState(
        items: items ?? this.items,
      );

  PhotoUploaderState itemUpserted(PhotoUploaderItem item) => copyWith(
        items: items.upsert([item]),
      );

  PhotoUploaderState itemExcluded(PhotoUploaderItem item) => copyWith(
        items: items.exclude(item.id),
      );

  PhotoUploaderItem? getItem(String id) =>
      items.firstWhereOrNull((item) => item.id == id);

  bool get ready => items.every((item) => item.status.isReady);
}

class PhotoUploaderItem extends Identifiable {
  PhotoUploaderItem({
    super.id,
    this.status = PhotoUploaderItemStatus.processing,
    required this.bytes,
    this.width,
    this.height,
    this.blurHash,
    required this.path,
  });

  final PhotoUploaderItemStatus status;
  final Uint8List bytes;
  final int? width;
  final int? height;
  final String? blurHash;
  final String path;

  PhotoUploaderItem copyWith({
    PhotoUploaderItemStatus? status,
    int? width,
    int? height,
    String? blurHash,
    Uint8List? bytes,
  }) =>
      PhotoUploaderItem(
        id: id,
        path: path,
        bytes: bytes ?? this.bytes,
        height: height ?? this.height,
        width: width ?? this.width,
        status: status ?? this.status,
        blurHash: blurHash ?? this.blurHash,
      );
}

enum PhotoUploaderItemStatus {
  processing,
  ready,
  failure;

  bool get isProcessing => this == PhotoUploaderItemStatus.processing;
  bool get isReady => this == PhotoUploaderItemStatus.ready;
  bool get isFailure => this == PhotoUploaderItemStatus.failure;
}
