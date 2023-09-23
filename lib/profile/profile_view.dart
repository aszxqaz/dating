import 'package:dating/assets/icons.dart';
import 'package:dating/chat/chat_view.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/misc/photos_preloader.dart';
import 'package:dating/supabase/models/model.dart';
import 'package:dating/user/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

part 'profile_cubit.dart';

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
      create: (_) => _Cubit(),
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
                          // --- PHOTO SLIDER
                          ? Stack(
                              children: [
                                Container(
                                  height: height * 0.6,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      const BoxShadow(blurRadius: 3),
                                      BoxShadow(
                                          color: Colors.black.withAlpha(50),
                                          offset: const Offset(0, -3))
                                    ],
                                  ),
                                  child: BlocListener<_Cubit, _State>(
                                    listenWhen: (p, c) =>
                                        p.heroEnabled != c.heroEnabled,
                                    listener: (context, state) {
                                      if (state.heroEnabled) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: BlocBuilder<_Cubit, _State>(
                                      buildWhen: (p, c) =>
                                          p.heroEnabled != c.heroEnabled,
                                      builder: (context, state) {
                                        return HeroMode(
                                          enabled: state.heroEnabled,
                                          child: Hero(
                                            tag: photos.elementAt(0).id,
                                            child: PhotoViewGallery.builder(
                                              pageController: pageController,
                                              onPageChanged: context
                                                  .read<_Cubit>()
                                                  .setIndex,
                                              scrollPhysics:
                                                  const ClampingScrollPhysics(),
                                              backgroundDecoration:
                                                  const BoxDecoration(
                                                color: Colors.black,
                                              ),
                                              builder: (context, index) {
                                                return PhotoViewGalleryPageOptions(
                                                  imageProvider: imageProviders
                                                      .elementAt(index),
                                                  minScale:
                                                      PhotoViewComputedScale
                                                          .covered,
                                                  maxScale:
                                                      PhotoViewComputedScale
                                                          .covered,
                                                  disableGestures: true,
                                                );
                                              },
                                              itemCount:
                                                  profile.photoUrls.length,
                                              loadingBuilder:
                                                  (context, progress) =>
                                                      const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // --- LIKES BUTTON
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: BlocBuilder<_Cubit, _State>(
                                    builder: (context, state) {
                                      return ShadowedLikesButton(
                                        onPressed: () {},
                                        count: photos
                                            .elementAt(state.photoIndex)
                                            .likes
                                            .length,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          // PHOTO PLACEHOLDER
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
                      // SLIDER INDICATOR
                      if (hasPhotos)
                        Positioned(
                          bottom: 12,
                          child: BlocBuilder<_Cubit, _State>(
                            builder: (context, state) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _SliderIndicator(
                                      activeIndex: state.photoIndex,
                                      count: profile.photoUrls.length,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      // BACK BUTTON
                      Positioned(
                        top: 8,
                        left: 8,
                        child: SafeArea(
                          child: ShadowedIconButton(
                            onPressed: () {
                              if (hasPhotos) {
                                context.read<_Cubit>().enableHero();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            icon: Icons.arrow_back_ios,
                            offset: const Offset(3, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        right: 110,
                        top: -8,
                        child: FilledIconButton(
                          onPressed: Navigator.of(context).pop,
                          icon: Ionicons.bookmark,
                          offset: const Offset(0, -2),
                          padding: 15,
                          size: 30,
                          bgColor: Colors.green,
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: -16,
                        child: FilledIconButton(
                          onPressed: () {
                            Navigator.of(context).push(Chat.route);
                          },
                          icon: Icons.message,
                          offset: const Offset(0, 2),
                          padding: 20,
                          size: 36,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      ),
                    ],
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
