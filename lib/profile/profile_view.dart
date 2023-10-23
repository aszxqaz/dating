import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/chat/chat_view.dart';
import 'package:dating/common/common.dart';
import 'package:dating/common/photo_slider/slider_indicator.dart';
import 'package:dating/features/chat/chats_bloc.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/common/wrapper_builder.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

part '_favourite_message.dart';
part '_photo_view_gallery.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profileId});

  static route({
    required BuildContext context,
    required String profileId,
  }) =>
      createRoute(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<ChatsBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProfilesBloc>(context)),
          ],
          child: ProfilePage(profileId: profileId),
        ),
      );

  final String profileId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  int initialPage = 0;

  late final ValueNotifier<int> indexNotifier;
  late final ValueNotifier<bool> fullscreen;
  late PageController pageController;

  @override
  initState() {
    fullscreen = ValueNotifier(false);
    indexNotifier = ValueNotifier(0);
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  dispose() {
    fullscreen.dispose();
    indexNotifier.dispose();
    pageController.dispose();
    super.dispose();
  }

  toggleFullscreen() {
    if (!fullscreen.value) {
      pageController.dispose();
      pageController = PageController(initialPage: indexNotifier.value);
    }
    fullscreen.value = !fullscreen.value;
  }

  setIndex(int page) {
    indexNotifier.value = page;
    initialPage = page;
  }

  @override
  Widget build(BuildContext context) {
    return WrapperBuilder(
      floatingActionButton: _FloatingActionButton(partnerId: widget.profileId),
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final sliderHeight = maxHeight * 0.6;
        final placeholderHeight = maxHeight * 0.5;

        return BlocSelector<ProfilesBloc, ProfilesState, Profile>(
          selector: (state) => state.getProfile(widget.profileId)!,
          builder: (context, profile) {
            final hasPhotos = profile.hasPhotos;
            final photoUrls = profile.photoUrls;

            final indicatoPos = maxWidth / 2 -
                SliderIndicator.calcWidth(profile.photoUrls.length) / 2;

            return ValueListenableBuilder(
              valueListenable: fullscreen,
              builder: (_, fullscreen, __) {
                final height = hasPhotos
                    ? fullscreen
                        ? maxHeight
                        : sliderHeight
                    : placeholderHeight;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: height,
                          width: maxWidth,
                          decoration: _photoSliderBoxDecoration,
                          child: hasPhotos
                              ? fullscreen
                                  ? _PhotoViewGallery(
                                      controller: pageController,
                                      onPageChanged: setIndex,
                                      photoUrls: photoUrls,
                                      contained: fullscreen,
                                    )
                                  : PhotoSlider(
                                      initialPage: initialPage,
                                      showIndicator: false,
                                      onPageChanged: setIndex,
                                      size: Size(maxWidth, sliderHeight),
                                      photoUrls: photoUrls,
                                    )
                              : SizedBox(
                                  height: placeholderHeight,
                                  child: const AvatarPlaceholder(),
                                ),
                        ),
                        if (hasPhotos)
                          Positioned(
                            bottom: 2,
                            left: 8,
                            right: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // --- LIKES BUTTON
                                // ---
                                ValueListenableBuilder(
                                  valueListenable: indexNotifier,
                                  builder: (_, index, __) {
                                    return PhotoLikeButton(
                                      profile: profile,
                                      photo: profile.photos[index],
                                    );
                                  },
                                ),

                                /// ---
                                /// --- FULLSCREEN BUTTON
                                /// ---
                                SafeArea(
                                  child: ShadowedIconButton(
                                    onPressed: toggleFullscreen,
                                    icon: fullscreen
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    offset: const Offset(0, 0),
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Positioned(
                          bottom: 12,
                          left: indicatoPos,
                          child: ValueListenableBuilder(
                            valueListenable: indexNotifier,
                            builder: (_, index, __) {
                              return SliderIndicator(
                                activeIndex: index,
                                count: profile.photoUrls.length,
                              );
                            },
                          ),
                        ),
                        if (!fullscreen)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: SafeArea(
                              child: ShadowedIconButton(
                                onPressed: Navigator.of(context).pop,
                                icon: Icons.arrow_back_ios,
                                offset: const Offset(3, 0),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (!fullscreen)
                      Stack(
                        children: [
                          SizedBox(
                            width: maxWidth,
                            // height: maxHeight - sliderHeight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 16,
                              ),
                              child: ProfileInfo(profile: profile),
                            ),
                          ),
                          // Positioned(
                          //   top: 16,
                          //   right: 8,
                          //   child: _FavouriteMessageRow(
                          //     sliderHeight: sliderHeight,
                          //     favouriteSize: favouriteSize,
                          //     messageSize: messageSize,
                          //     partnerId: profile.userId,
                          //   ),
                          // ),
                        ],
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class PhotoLikeButton extends StatelessWidget {
  const PhotoLikeButton({
    super.key,
    required this.profile,
    required this.photo,
  });

  final Profile profile;
  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return ShadowedLikesButton(
      onPressed: () async {
        ProfilesBloc.of(context).likePhoto(profile.userId, photo.id);
      },
      count: photo.likes.length,
      liked: photo.likes.contains(requireUser.id),
    );
  }
}

const _photoSliderBoxDecoration = BoxDecoration(
  boxShadow: [
    // BoxShadow(blurRadius: 5),
    BoxShadow(blurRadius: 5, color: Colors.black54, offset: Offset(0, 0)),
  ],
);

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({required this.partnerId});

  final String partnerId;

  @override
  Widget build(BuildContext context) {
    return FilledIconButton(
      onPressed: () {
        Navigator.of(context).push(createRightBottomFadeScaleRoute(
          ChatView.routeWidget(
            context: context,
            partnerId: partnerId,
          ),
        ));
      },
      icon: Icons.message,
      offset: const Offset(0, 2),
      padding: 15,
      size: 36,
    );
  }
}
