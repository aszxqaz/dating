import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickPhoto() async {
  try {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo == null || !photo.path.endsWith('.jpg')) {
      return null;
    }

    final bytes = defaultTargetPlatform != TargetPlatform.windows
        ? await FlutterImageCompress.compressWithFile(
            minWidth: 800,
            minHeight: 1200,
            photo.path,
            quality: 50,
          )
        : await photo.readAsBytes();

    return bytes;
  } catch (e) {
    debugPrint(e.toString());
  }

  return null;
}

Future<List<Uint8List>?> pickMultiPhoto() async {
  try {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();

    if (files.isEmpty) {
      return null;
    }

    final List<Uint8List> bytesArr = [];

    await Future.wait(files.map((file) async {
      final bytes = defaultTargetPlatform != TargetPlatform.windows
          ? await FlutterImageCompress.compressWithFile(
              minWidth: 800,
              minHeight: 1200,
              file.path,
              quality: 50,
            )
          : await file.readAsBytes();
      if (bytes != null) {
        bytesArr.add(bytes);
      }
    }));

    if (bytesArr.isEmpty) return null;

    return bytesArr;
  } catch (e) {
    debugPrint(e.toString());
  }

  return null;
}

Future<List<XFile>?> tryPickMultiImage() async {
  try {
    final picker = ImagePicker();
    return await picker.pickMultiImage();
  } catch (e) {
    debugPrint('Error trying picking images: $e');
    return null;
  }
}
