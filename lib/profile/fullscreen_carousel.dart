import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullscreenCarousel extends StatelessWidget {
  const FullscreenCarousel({super.key, required this.photoUrls});

  static route(Iterable<String> photoUrls) => MaterialPageRoute(
        builder: (_) => FullscreenCarousel(photoUrls: photoUrls),
      );

  final Iterable<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FullscreenCarouselCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: context.read<FullscreenCarouselCubit>().toggleUiShown,
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(photoUrls.elementAt(index)),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 1.5,
                      );
                    },
                    itemCount: photoUrls.length,
                    loadingBuilder: (context, progress) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<FullscreenCarouselCubit, FullscreenCarouselState>(
              buildWhen: (p, c) => p.uiShown != c.uiShown,
              builder: (_, state) => state.uiShown
                  ? Positioned(
                      child: Material(
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white60,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class FullscreenCarouselState {
  const FullscreenCarouselState({required this.uiShown});

  static const initial = FullscreenCarouselState(uiShown: false);

  final bool uiShown;

  FullscreenCarouselState copyWith({bool? uiShown}) =>
      FullscreenCarouselState(uiShown: uiShown ?? this.uiShown);
}

class FullscreenCarouselCubit extends Cubit<FullscreenCarouselState> {
  FullscreenCarouselCubit() : super(FullscreenCarouselState.initial);

  void toggleUiShown() => emit(state.copyWith(uiShown: !state.uiShown));
}
