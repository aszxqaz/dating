import 'package:dating/misc/extensions.dart';
import 'package:flutter/material.dart';

class OnlineLabel extends StatelessWidget {
  const OnlineLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '● online',
      style: context.textTheme.bodySmall!.copyWith(color: Colors.lightGreen),
    );
  }
}
