part of 'chat_view.dart';

class _ChatMessageWidget extends HookWidget {
  const _ChatMessageWidget({
    super.key,
    required this.message,
    required this.color,
  });

  final ChatMessageNew message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.now();
    final hasTime = message.createdAt != null;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                ),
                softWrap: true,
              ),
              Row(
                children: [
                  const Spacer(),
                  if (hasTime) ...[
                    Text(
                      message.createdAt!.localTime,
                      style: context.textTheme.bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ] else
                    const Icon(
                      Icons.sync_outlined,
                      size: 12,
                      color: Colors.white,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
