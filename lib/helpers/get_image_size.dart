import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

Size? getImageSize(String path) {
  try {
    final file = File(path);
    final size = ImageSizeGetter.getSize(FileInput(file));
    return size;
  } catch (e) {
    debugPrint('Error getting image size: $e');
    return null;
  }
}
