part of '../chat_view.dart';

class _TextMessage extends StatelessWidget {
  const _TextMessage({
    required this.message,
    required this.bgColor,
  });

  final ChatMessage message;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final text = message.text!;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200, minWidth: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),
                softWrap: true,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, top: 8),
                  child: _MessageMetaInfo(message: message),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
