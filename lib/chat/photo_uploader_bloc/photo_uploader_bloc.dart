import 'package:collection/collection.dart';
import 'package:dating/helpers/compress_photo.dart';
import 'package:dating/helpers/get_blur_hash.dart';
import 'package:dating/interfaces/identifiable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:image/image.dart' as imagePackage;

part 'photo_uploader_event.dart';
part 'photo_uploader_state.dart';

// @pragma('vm:entry-point')
// _compressPhoto(Uint8List bytes) async {
//   return await compressPhoto(bytes);
// }

class PhotoUploaderBloc extends Bloc<_PhotoUploaderEvent, PhotoUploaderState> {
  PhotoUploaderBloc(this.context) : super(const PhotoUploaderState(items: [])) {
    on<_AddFiles>(_onBytesAdded);
    on<_ItemsProcessed>(_onItemsProccessed);
    on<_ProcessSingle>(_onProcessSingle);
  }

  BuildContext context;

  static PhotoUploaderBloc of(BuildContext context) =>
      context.read<PhotoUploaderBloc>();

  _onBytesAdded(_AddFiles event, Emitter<PhotoUploaderState> emit) async {
    for (final file in event.files) {
      final initialBytes = await file.readAsBytes();

      if (context.mounted) {
        await precacheImage(MemoryImage(initialBytes), context);
      }

      final item = PhotoUploaderItem(bytes: initialBytes, path: file.path);

      emit(state.itemUpserted(item));

      add(_ItemsProcessed(itemId: item.id));
    }
    // await Future.wait(event.files.map((file) async {
    // // compress and display to ui
    // final initialBytes = await file.readAsBytes();
    // final item = PhotoUploaderItem(bytes: initialBytes, path: file.path);
    // emit(state.itemUpserted(item));

    //   final compressedBytes = await compressPhoto(initialBytes) ?? initialBytes;

    //   final compressed = item.copyWith(bytes: compressedBytes);

    //   emit(state.itemUpserted(compressed));

    //   add(_ItemsProcessed(itemId: item.id));
    // }));
  }

  _onProcessSingle(
    _ProcessSingle event,
    Emitter<PhotoUploaderState> emit,
  ) async {
    // final file = event.file;
    // final initialBytes = await file.readAsBytes();

    // if (context.mounted) {
    //   await precacheImage(MemoryImage(initialBytes), context);
    // }

    // final item = PhotoUploaderItem(bytes: initialBytes, path: file.path);
    // emit(state.itemUpserted(item));
  }

  _onItemsProccessed(
      _ItemsProcessed event, Emitter<PhotoUploaderState> emit) async {
    debugPrint('ON ITEMS PROCESS STARTED');

    var item = state.items.firstWhereOrNull((item) => item.id == event.itemId);

    if (item == null) {
      return;
    }

    final compressedBytes = await compressPhoto(item.bytes) ?? item.bytes;

    item = item.copyWith(bytes: compressedBytes);

    // emit(state.itemUpserted(compressed));

    final evenMoreCompressed =
        await compressPhoto(compressedBytes, 200, 300) ?? item.bytes;

    final image = await compute((bytes) {
      return imagePackage.decodeJpg(bytes);
    }, evenMoreCompressed);

    if (image == null) {
      final failed = item.copyWith(status: PhotoUploaderItemStatus.failure);
      emit(state.itemUpserted(failed));
      return null;
    }

    final now = DateTime.now();

    final blurHash = await compute((image) {
      return getBlurHash(image);
    }, image);

    debugPrint(
        'BLUR HASH TIME FOR SIZE (${image.width}, ${image.height}) : ${DateTime.now().difference(now).inMilliseconds} MS');

    final completed = item.copyWith(
      width: image.width,
      height: image.height,
      status: PhotoUploaderItemStatus.ready,
      blurHash: blurHash,
    );

    emit(state.itemUpserted(completed));

    debugPrint('ON ITEMS PROCESS COMPLETED');
  }

  // ---
  // --- PUBLIC API
  // ---
  processFiles(List<XFile> files) {
    add(_AddFiles(files: files));
  }

  excludePhoto(String id) {}
}
