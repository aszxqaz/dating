part of 'user_view.dart';

class _ChipsWrap extends StatelessWidget {
  const _ChipsWrap({
    required this.title,
    required this.labels,
    required this.icon,
    required this.onSelected,
    required this.onDeselected,
    required this.selected,
  });

  final String title;
  final Widget icon;

  final Iterable<String> labels;

  final Function(int index) onSelected;
  final VoidCallback onDeselected;
  final bool Function(int index) selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: labels
                    .whereNot((label) => label == '')
                    .mapIndexed(
                      (index, label) => _PrefChip(
                        label: label,
                        selected: selected(index + 1),
                        onSelected: () {
                          if (selected(index + 1)) {
                            onDeselected();
                          } else {
                            onSelected(index + 1);
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
