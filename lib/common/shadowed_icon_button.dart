import 'package:dating/misc/extensions.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ShadowedLikesButton extends StatefulWidget {
  const ShadowedLikesButton({
    super.key,
    required this.onPressed,
    required this.count,
    required this.liked,
  });

  final VoidCallback onPressed;
  final int count;
  final bool liked;

  @override
  State<ShadowedLikesButton> createState() => _ShadowedLikesButtonState();
}

class _ShadowedLikesButtonState extends State<ShadowedLikesButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<Color?> colorAnimation;

  final _redColor = Colors.red.withAlpha(180);
  final _whiteColor = Colors.white.withAlpha(180);

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 1.3)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.3, end: 1)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1)
    ]).animate(controller);

    setColorAnimation();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ShadowedLikesButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  setColorAnimation() {
    if (widget.liked) {
      colorAnimation =
          ColorTween(begin: _redColor, end: _whiteColor).animate(controller);
    } else {
      colorAnimation =
          ColorTween(begin: _whiteColor, end: _redColor).animate(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(150),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          widget.onPressed();
          if (controller.status == AnimationStatus.dismissed) {
            controller.forward();
          }

          if (controller.status == AnimationStatus.completed) {
            controller.reverse();
          }
        },
        splashColor: context.colorScheme.primary.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 9),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: scaleAnimation,
                child: AnimatedBuilder(
                    animation: colorAnimation,
                    builder: (context, _) {
                      var color = colorAnimation.value;
                      // if (colorAnimation.status == AnimationStatus.dismissed ||
                      //     colorAnimation.status == AnimationStatus.completed) {
                      //   color = widget.liked ? _redColor : _whiteColor;
                      // }

                      return Icon(
                        Ionicons.heart,
                        size: 22,
                        color: color,
                      );
                    }),
              ),
              const SizedBox(width: 8),
              Text(
                widget.count.toString(),
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
      color: Colors.black.withAlpha(180),
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
              color: Colors.white.withAlpha(180),
            ),
          ),
        ),
      ),
    );
  }
}
