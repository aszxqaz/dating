import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/common/avatar_placeholder.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto(
    this.url, {
    super.key,
    this.size,
    this.circle = false,
  });

  final Size? size;
  final String? url;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size?.width,
      height: size?.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(182, 244, 255, 1),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child:
          url != null ? _buildCachedNetworkImage() : const AvatarPlaceholder(),
    );
  }

  _buildImage() => Image.network(
        url!,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress == null
              ? child
              : Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        },
      );

  _buildFadeInImage() => FadeInImage(
        placeholder: const AssetImage('assets/gifs/spinner.gif'),
        image: NetworkImage(url!),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        placeholderFit: BoxFit.scaleDown,
      );

  _buildCachedNetworkImage() => CachedNetworkImage(
        imageUrl: url!,
        errorWidget: (context, url, error) => const AvatarPlaceholder(),
        placeholder: (context, url) => Image.asset(
          'assets/gifs/spinner.gif',
          alignment: Alignment.center,
          fit: BoxFit.scaleDown,
        ),
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
}
