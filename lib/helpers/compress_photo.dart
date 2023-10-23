import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List?> compressPhoto(Uint8List photo,
    [int minWidth = 800, int minHeight = 1200]) async {
  if (Platform.isWindows) {
    return null;
  } else {
    final bytes = await FlutterImageCompress.compressWithList(
      minWidth: minWidth,
      minHeight: minHeight,
      photo,
      quality: 50,
    );
    return bytes;
  }
}
