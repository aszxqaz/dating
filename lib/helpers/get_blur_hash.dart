import 'dart:math';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart' as blurhash;
import 'package:blurhash/blurhash.dart' as blurhash2;
import 'package:image/image.dart';
import 'package:image_size_getter/image_size_getter.dart';

String getBlurHash(Image image) {
  final baseSize = max(image.width, image.height);
  final compX = (image.width / baseSize * 4).round();
  final compY = (image.height / baseSize * 4).round();

  final blurHash = blurhash.BlurHash.encode(
    image,
    numCompX: compX,
    numCompY: compY,
  ).hash;

  return blurHash;
}

Future<String> getBlurHash2(Uint8List bytes, Size size) async {
  final baseSize = max(size.width, size.height);

  final compX = (size.width / baseSize * 4).round();
  final compY = (size.height / baseSize * 4).round();

  final blurHash = await blurhash2.BlurHash.encode(bytes, compX, compY);
  return blurHash;
}
