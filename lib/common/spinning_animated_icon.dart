import 'package:dating/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class _SpinningAnimatedIcon extends StatefulWidget {
  const _SpinningAnimatedIcon({
    this.color = colorsWhite80,
    this.size = 12,
    this.icon = Icons.sync,
    this.speed = 1.0,
  });

  final Color color;
  final double size;
  final IconData icon;
  final double speed;

  @override
  State<_SpinningAnimatedIcon> createState() => _SpinningAnimatedIconState();
}

class _SpinningAnimatedIconState extends State<_SpinningAnimatedIcon>
    with SingleTickerProviderStateMixin {
  double turns = 0;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      inc();
    });
    super.didChangeDependencies();
  }

  void inc() {
    setState(() {
      turns += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final factor = 1 / widget.speed;
    final ms = (factor * 1000).round();

    return AnimatedRotation(
      turns: turns,
      duration: Duration(milliseconds: ms),
      onEnd: inc,
      child: Icon(
        widget.icon,
        // color: Colors.white,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}

const syncAnimatedIconLarge = _SpinningAnimatedIcon(
  color: Colors.white70,
  size: 26,
  icon: Ionicons.sync_outline,
);

const syncAnimatedIconSmallest = _SpinningAnimatedIcon();
