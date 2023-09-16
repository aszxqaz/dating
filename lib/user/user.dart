// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dating/assets/icons.dart';
import 'package:dating/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Profile',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: double.maxFinite,
                      child: AspectRatio(
                        aspectRatio: 0.5,
                        child: Image.asset(
                          'assets/marmot.jpg',
                          alignment: Alignment.center,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Maxim',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _ProfilePropertyRow(src: IconAssets.cake, text: '28 y.o.'),
            const SizedBox(height: 8),
            _ProfilePropertyRow(src: IconAssets.location, text: 'Batumi'),
            const SizedBox(height: 8),
            _ProfilePropertyRow(src: IconAssets.yinyang, text: 'Hetero'),
            const SizedBox(height: 8),
            _ProfilePropertyRow(src: IconAssets.calendar, text: '18-35 y.o.'),
          ],
        ),
      ),
    );
  }
}

class _ProfilePropertyIcon extends StatelessWidget {
  const _ProfilePropertyIcon({
    super.key,
    required this.src,
  });

  final String src;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        src,
        colorFilter: ColorFilter.mode(
          context.colorScheme.onPrimaryContainer,
          // Colors.black,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _ProfilePropertyRow extends StatelessWidget {
  const _ProfilePropertyRow({
    super.key,
    required this.src,
    required this.text,
  });

  final String src;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ProfilePropertyIcon(src: src),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
