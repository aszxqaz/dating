// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating/assets/icons.dart';
import 'package:dating/home/bloc/home_bloc.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/service.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Center(
            child: BlocBuilder<UserBloc, UserState>(
                buildWhen: (previous, current) =>
                    previous.photos != current.photos,
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
                                    loadingBuilder: (context, child,
                                            loadingProgress) =>
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
                                                  child:
                                                      CircularProgressIndicator(),
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
                }),
          ),
          const SizedBox(height: 16),
          Text(
            'Maxim',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _ProfilePropertyRow(src: IconAssets.cake, text: '28 y.o.'),
          const SizedBox(height: 8),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (p, c) => p.location != c.location,
            builder: (_, state) {
              return _ProfilePropertyRow(
                src: IconAssets.location,
                text:
                    state.location.isNotEmpty ? state.location.displayPair : '',
              );
            },
          ),
          const SizedBox(height: 8),
          _ProfilePropertyRow(src: IconAssets.yinyang, text: 'Hetero'),
          const SizedBox(height: 8),
          _ProfilePropertyRow(src: IconAssets.calendar, text: '18-35 y.o.'),
        ],
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
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      shape: CircleBorder(side: BorderSide.none),
      child: InkWell(
        onTap: onPressed,
        customBorder: CircleBorder(),
        splashColor: context.colorScheme.primary.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Transform.translate(
            offset: offset ?? Offset(0, 0),
            child: Icon(
              icon,
              size: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
