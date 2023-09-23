import 'package:flutter/material.dart';

class PhotosPreloader extends StatefulWidget {
  const PhotosPreloader({super.key, required this.imageProviders});

  final Iterable<ImageProvider> imageProviders;

  @override
  State<PhotosPreloader> createState() => _PhotosPreloaderState();
}

class _PhotosPreloaderState extends State<PhotosPreloader> {
  @override
  void didChangeDependencies() {
    for (final provider in widget.imageProviders) {
      precacheImage(provider, context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
