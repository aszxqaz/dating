// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:dating/assets/icons.dart';
import 'package:dating/home/bloc/home_bloc.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/preferences/preferences.dart';
import 'package:dating/supabase/service.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

part 'user_preferences.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return _UserView();
  }
}

class _UserView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<UserBloc>().loadPhotos();
      context.read<UserBloc>().listen();
      return null;
    }, []);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return state.profile == null
            ? Center(child: const CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Profile',
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _PhotoSlider(),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            state.profile!.name,
                            style: context.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _ProfilePropertyRow(
                              src: IconAssets.cake, text: '28 y.o.'),
                          const SizedBox(height: 8),
                          BlocBuilder<HomeBloc, HomeState>(
                            buildWhen: (p, c) => p.location != c.location,
                            builder: (_, state) {
                              return _ProfilePropertyRow(
                                src: IconAssets.location,
                                text: state.location.isNotEmpty
                                    ? state.location.displayPair
                                    : '',
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _ProfilePropertyRow(
                              src: IconAssets.yinyang, text: 'Hetero'),
                          const SizedBox(height: 8),
                          _ProfilePropertyRow(
                              src: IconAssets.calendar, text: '18-35 y.o.'),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.lookingFor !=
                                c.profile?.prefs.lookingFor,
                            builder: (context, state) {
                              return _LookingForChipsWrap(
                                groupValue: state.profile?.prefs.lookingFor,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('looking_for', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('looking_for', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.lovelang !=
                                c.profile?.prefs.lovelang,
                            builder: (context, state) {
                              return _LoveLanguageChipsWrap(
                                groupValue: state.profile?.prefs.lovelang,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('love_lang', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('love_lang', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.nutrition !=
                                c.profile?.prefs.nutrition,
                            builder: (context, state) {
                              return _NutritionChipsWrap(
                                groupValue: state.profile?.prefs.nutrition,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('nutrition', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('nutrition', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.pets != c.profile?.prefs.pets,
                            builder: (context, state) {
                              return _PetsChipsWrap(
                                groupValue: state.profile?.prefs.pets,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('pets', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('pets', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.alcohol !=
                                c.profile?.prefs.alcohol,
                            builder: (context, state) {
                              return _AlcoholChipsWrap(
                                groupValue: state.profile?.prefs.alcohol,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('alcohol', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('alcohol', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.smoking !=
                                c.profile?.prefs.smoking,
                            builder: (context, state) {
                              return _SmokingChipsWrap(
                                groupValue: state.profile?.prefs.smoking,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('smoking', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('smoking', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.education !=
                                c.profile?.prefs.education,
                            builder: (context, state) {
                              return _EducationChipsWrap(
                                groupValue: state.profile?.prefs.education,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('education', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('education', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.children !=
                                c.profile?.prefs.children,
                            builder: (context, state) {
                              return _ChildrenChipsWrap(
                                groupValue: state.profile?.prefs.children,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('children', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('children', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserBloc, UserState>(
                            buildWhen: (p, c) =>
                                p.profile?.prefs.workout !=
                                c.profile?.prefs.workout,
                            builder: (context, state) {
                              return _WorkoutChipsWrap(
                                groupValue: state.profile?.prefs.workout,
                                onSelected: (index) {
                                  context
                                      .read<UserBloc>()
                                      .changePref('workout', index);
                                },
                                onDeselected: () {
                                  context
                                      .read<UserBloc>()
                                      .changePref('workout', null);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class _ProfilePropertyIcon extends StatelessWidget {
  const _ProfilePropertyIcon({
    required this.src,
  });

  final String src;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: SvgPicture.asset(
        src,
        colorFilter: ColorFilter.mode(
          context.colorScheme.primary,
          // Colors.black,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _ProfilePropertyRow extends StatelessWidget {
  const _ProfilePropertyRow({
    required this.src,
    required this.text,
  });

  final String src;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfilePropertyIcon(src: src),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class ShadowedIconButton extends StatelessWidget {
  const ShadowedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.offset,
    this.size = 16.0,
    this.padding = 12.0,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Offset? offset;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(150),
      shape: CircleBorder(side: BorderSide.none),
      child: InkWell(
        onTap: onPressed,
        customBorder: CircleBorder(),
        splashColor: context.colorScheme.primary.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Transform.translate(
            offset: offset ?? Offset(0, 0),
            child: Icon(
              icon,
              size: size,
              color: Colors.white.withAlpha(180),
            ),
          ),
        ),
      ),
    );
  }
}

class ShadowedLikesButton extends StatelessWidget {
  const ShadowedLikesButton({
    super.key,
    required this.onPressed,
    required this.count,
  });

  final VoidCallback onPressed;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(150),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onPressed,
        splashColor: context.colorScheme.primary.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 9),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Ionicons.heart,
                size: 22,
                color: Colors.white.withAlpha(180),
              ),
              const SizedBox(width: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilledIconButton extends StatelessWidget {
  const FilledIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.offset,
    this.size = 16.0,
    this.padding = 12.0,
    this.iconColor = Colors.white70,
    this.bgColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Offset? offset;
  final double size;
  final double padding;
  final Color? iconColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? context.colorScheme.primary,
      elevation: 10,
      shape: CircleBorder(side: BorderSide.none),
      child: InkWell(
        onTap: onPressed,
        customBorder: CircleBorder(),
        splashColor: context.colorScheme.primary.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Transform.translate(
            offset: offset ?? Offset(0, 0),
            child: Icon(
              icon,
              size: size,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previous, current) => previous.photos != current.photos,
        builder: (context, state) {
          final hasPhotos = state.links?.isNotEmpty == true;

          return Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 1.1,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
                items: (state.links ?? [])
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 300,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(
                                            238,
                                            238,
                                            238,
                                            1,
                                          ),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (hasPhotos) ...[
                Positioned(
                  bottom: 8,
                  right: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // final result = await pickImage(context);
                        // carousel = UniqueKey();
                      },
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        size: 32,
                        color: Colors.redAccent.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
              Positioned(
                bottom: 8,
                left: 24,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        await pickImage(context);
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 32,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null && photo.path.endsWith('.jpg') && context.mounted) {
      final bytes = await FlutterImageCompress.compressWithFile(
        minWidth: 800,
        minHeight: 1200,
        photo.path,
        quality: 50,
      );

      if (bytes == null) return false;

      await RepositoryProvider.of<SupabaseService>(context)
          .uploadPhoto(bytes: bytes);
      context.read<UserBloc>().loadPhotos();
      return true;
    }
    return false;
  }
}
