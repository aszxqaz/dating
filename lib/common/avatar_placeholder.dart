import 'package:dating/assets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarPlaceholder extends StatelessWidget {
  const AvatarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: const Color.fromRGBO(182, 244, 255, 1),
      child: SvgPicture.asset(
        IconAssets.userPlaceholder,
        colorFilter: const ColorFilter.mode(
          Color.fromRGBO(146, 216, 227, 1),
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      ),
    );
  }
}
