part of 'chat_view.dart';

class _MessagesScrollView extends StatefulWidget {
  const _MessagesScrollView({
    required this.messages,
  });

  final List<ChatMessage> messages;

  @override
  State<_MessagesScrollView> createState() => _MessagesScrollViewState();
}

class _MessagesScrollViewState extends State<_MessagesScrollView> {
  final controller = ScrollController();
  bool reverse = false;

  @override
  void didUpdateWidget(covariant _MessagesScrollView oldWidget) {
    // controller.jumpTo(controller.position.maxScrollExtent);
    updateReverse();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // scroll(500);
      updateReverse();
    });
    super.didChangeDependencies();
  }

  updateReverse() {
    setState(() {
      reverse = controller.position.maxScrollExtent >
          controller.position.minScrollExtent;
    });
  }

  void scroll(int ms) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: Duration(milliseconds: ms),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messages;

    return SingleChildScrollView(
      reverse: reverse,
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
        child: Column(
          children: messages.mapIndexed<Widget>(
            (index, message) {
              final last = index == messages.length - 1;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Align(
                  alignment:
                      message.incoming ? Alignment.topLeft : Alignment.topRight,
                  child: _ChatMessageWidget(message: message),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
