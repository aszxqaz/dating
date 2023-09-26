part of 'chat_view.dart';

class _MessagesScrollView extends StatefulWidget {
  const _MessagesScrollView({
    super.key,
    required this.messages,
  });

  final List<ChatMessageNew> messages;

  @override
  State<_MessagesScrollView> createState() => _MessagesScrollViewState();
}

class _MessagesScrollViewState extends State<_MessagesScrollView> {
  final controller = ScrollController();

  @override
  void didUpdateWidget(covariant _MessagesScrollView oldWidget) {
    controller.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      reverse: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16,
        ),
        child: Column(
          children: widget.messages.map(
            (message) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment:
                      message.incoming ? Alignment.topLeft : Alignment.topRight,
                  child: _ChatMessageWidget(
                    message: message,
                    color: message.incoming
                        ? Colors.lightGreen.shade700
                        : Colors.lightBlue,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
