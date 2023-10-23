part of '../chat_view.dart';

class _ChatMessageWidget extends StatelessWidget {
  const _ChatMessageWidget({
    required this.message,
    required this.constraintsWidth,
  });

  final ChatMessage message;
  final double constraintsWidth;

  @override
  Widget build(BuildContext context) {
    final bgColor = message.incoming
        ? message.read
            ? Colors.lightBlue
            : Colors.lightBlue.shade900
        : Colors.lightGreen;

    if (message.photos != null && message.photos!.isNotEmpty) {
      return _PhotoMessage(
        message: message,
        bgColor: bgColor,
        constraintsWidth: constraintsWidth,
      );
    }

    if (message.text != null && message.text!.isNotEmpty) {
      return _TextMessage(
        message: message,
        bgColor: bgColor,
      );
    }

    return const SizedBox.shrink();
  }
}
