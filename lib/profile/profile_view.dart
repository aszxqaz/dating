// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating/assets/icons.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/models/model.dart';
import 'package:dating/supabase/models/photo.dart';
import 'package:dating/user/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key, required this.profile});

  static route(Profile profile) => MaterialPageRoute(
        builder: (_) => ProfilePage(profile: profile),
      );

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final photos = profile.photos;
    final hasPhotos = photos.isNotEmpty;
    final pageController = usePageController();

    final imageProviders = useMemoized(
      () => profile.photoUrls.map((url) => NetworkImage(url)),
      [profile.photos],
    );

    return BlocProvider(
      create: (_) => PageCubit(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) {
              final height = MediaQuery.of(context).size.height;
              final width = MediaQuery.of(context).size.width;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhotosPreloader(imageProviders: imageProviders),
                  Stack(
                    children: [
                      hasPhotos
                          ? Container(
                              height: height * 0.6,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(blurRadius: 3),
                                  BoxShadow(
                                      color: Colors.black.withAlpha(50),
                                      offset: Offset(0, -3))
                                ],
                              ),
                              child: Hero(
                                tag: photos.elementAt(0).id,
                                child: PhotoViewGallery.builder(
                                  pageController: pageController,
                                  onPageChanged: context.read<PageCubit>().set,
                                  scrollPhysics: const ClampingScrollPhysics(),
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.black),
                                  builder: (context, index) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider:
                                          imageProviders.elementAt(index),
                                      minScale: PhotoViewComputedScale.covered,
                                      maxScale: PhotoViewComputedScale.covered,
                                      disableGestures: true,
                                    );
                                  },
                                  itemCount: profile.photoUrls.length,
                                  loadingBuilder: (context, progress) =>
                                      const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: width * 0.7,
                              width: width,
                              color: context.colorScheme.primaryContainer
                                  .withOpacity(0.7),
                              child: SvgPicture.asset(
                                IconAssets.userPlaceholder,
                                colorFilter: ColorFilter.mode(
                                  context.colorScheme.primary.withOpacity(0.2),
                                  BlendMode.srcIn,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                      if (hasPhotos)
                        Positioned(
                          bottom: 8,
                          child: BlocBuilder<PageCubit, int>(
                            builder: (context, page) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _SliderIndicator(
                                      activeIndex: page,
                                      count: profile.photoUrls.length,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: ShadowedIconButton(
                          onPressed: Navigator.of(context).pop,
                          icon: Icons.arrow_back_ios,
                          offset: Offset(2, 0),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          profile.name,
                          style: context.textTheme.titleLarge!.copyWith(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (profile.location.isNotEmpty)
                          Text(profile.location.displayPair),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SliderIndicator extends StatelessWidget {
  const _SliderIndicator({
    required this.activeIndex,
    required this.count,
  });

  final int activeIndex;
  final int count;

  static const opacities = [0.22, 0.17, 0.1, 0.05];
  // static const circleSize

  @override
  Widget build(BuildContext context) {
    return count > 1
        ? Material(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: List.generate(
                  count * 2 - 1,
                  (index) => index % 2 == 0
                      ? Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            // shape: BoxShape.circle,
                            color: index == activeIndex * 2
                                ? Colors.white.withOpacity(0.7)
                                : Colors.white.withOpacity(0.2),
                          ),
                        )
                      : const SizedBox(
                          width: 8,
                        ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class PageCubit extends Cubit<int> {
  PageCubit() : super(0);

  void set(int page) {
    emit(page);
  }
}

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
