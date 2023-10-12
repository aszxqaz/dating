part of 'profile_view.dart';

class _PhotoViewGallery extends StatelessWidget {
  const _PhotoViewGallery({
    this.controller,
    this.onPageChanged,
    required this.contained,
    required this.photoUrls,
  });

  final Iterable<String> photoUrls;
  final bool contained;
  final PageController? controller;
  final void Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery(
      pageController: controller,
      onPageChanged: onPageChanged,
      scrollPhysics: const ClampingScrollPhysics(),
      pageOptions: photoUrls
          .map(
            (url) => PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(url),
              // initialScale:
              //     PhotoViewComputedScale
              //         .covered,
              initialScale: contained
                  ? PhotoViewComputedScale.contained
                  : PhotoViewComputedScale.covered,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 1.5,
            ),
          )
          .toList(),
      loadingBuilder: (context, progress) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
