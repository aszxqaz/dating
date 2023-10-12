part of 'user_view.dart';

class _PrefChip extends StatelessWidget {
  const _PrefChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? context.colorScheme.primary : Colors.black,
        ),
      ),
      color: selected ? context.colorScheme.primary : Colors.transparent,
      animationDuration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: onSelected,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 6),
          child: Text(
            label,
            style: context.textTheme.bodyMedium!.copyWith(
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
