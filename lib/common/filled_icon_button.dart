import 'package:dating/misc/extensions.dart';
import 'package:flutter/material.dart';

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
      shape: const CircleBorder(side: BorderSide.none),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: context.colorScheme.primary.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Transform.translate(
            offset: offset ?? const Offset(0, 0),
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
