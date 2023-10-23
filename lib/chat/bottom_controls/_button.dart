part of '../chat_view.dart';

class _BottomControlsButton extends StatelessWidget {
  const _BottomControlsButton({
    required this.onPressed,
    required this.icon,
    this.disabled = false,
    this.size,
    this.offset = const Offset(0, 0),
  });

  final VoidCallback onPressed;
  final bool disabled;
  final IconData icon;
  final double? size;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size.fromRadius(24)),
      onPressed: disabled ? null : onPressed,
      shape: const CircleBorder(),
      child: Transform.translate(
        offset: offset,
        child: Icon(
          icon,
          color: disabled ? Colors.white38 : Colors.white,
          size: size,
        ),
      ),
    );
  }
}
