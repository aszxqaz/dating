part of '../chat_view.dart';

class _MessageMetaInfo extends StatelessWidget {
  const _MessageMetaInfo({
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return message.sent
        ? Text.rich(
            TextSpan(
              children: [
                // --- TIME
                TextSpan(
                  text: message.createdAt.shortStringTime,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 4),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.check,
                    size: 12,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 4),
                ),
                WidgetSpan(
                  child: message.read
                      ? const Icon(
                          Ionicons.eye_outline,
                          size: 12,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        )
                      : const Icon(
                          Ionicons.eye_off_outline,
                          size: 12,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                ),
              ],
            ),
          )
        : syncAnimatedIconSmallest;
  }
}
