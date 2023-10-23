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
  final reverse = ValueNotifier(false);

  @override
  void didUpdateWidget(covariant _MessagesScrollView oldWidget) {
    if (widget.messages.length != oldWidget.messages.length) {
      updateReverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateReverse();
    });
    super.didChangeDependencies();
  }

  updateReverse() {
    reverse.value = controller.position.maxScrollExtent >
        controller.position.minScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messages;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder(
          valueListenable: reverse,
          builder: (_, reverse, child) {
            return SingleChildScrollView(
              reverse: reverse,
              controller: controller,
              child: child,
            );
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: StripesBackground(
                color: Colors.lightBlue.withAlpha(20),
                strokeWidth: 4,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: messages.mapIndexed<Widget>(
                        (index, message) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Align(
                              alignment: message.incoming
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: _ChatMessageWidget(
                                message: message,
                                constraintsWidth: constraints.maxWidth,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
