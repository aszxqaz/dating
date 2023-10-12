part of 'chat_view.dart';

class _ChatMessageWidget extends HookWidget {
  const _ChatMessageWidget({
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final createdAt = message.createdAt;
    final sent = message.sent;
    final incoming = message.incoming;
    final read = message.read;

    final bgColor = incoming
        ? read
            ? Colors.lightBlue
            : Colors.lightBlue.shade900
        : Colors.lightGreen;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        elevation: 2,
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
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      const Spacer(),
                      // --- TIME
                      if (sent) ...[
                        Text(
                          createdAt.shortStringTime,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: const Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check,
                          size: 12,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                        const SizedBox(width: 4),
                        if (message.read)
                          const Icon(
                            Ionicons.eye_outline,
                            size: 12,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                          )
                        else
                          const Icon(
                            Ionicons.eye_off_outline,
                            size: 12,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                      ] else
                        _syncedIcon
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _syncedIcon = _SyncAnimatedIcon();

class _SyncAnimatedIcon extends StatefulWidget {
  const _SyncAnimatedIcon();

  @override
  State<_SyncAnimatedIcon> createState() => _SyncAnimatedIconState();
}

class _SyncAnimatedIconState extends State<_SyncAnimatedIcon>
    with SingleTickerProviderStateMixin {
  double turns = 0;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      inc();
    });
    super.didChangeDependencies();
  }

  void inc() {
    setState(() {
      turns += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: const Duration(seconds: 1),
      onEnd: inc,
      child: const Icon(
        Icons.sync,
        size: 12,
        color: Color.fromRGBO(255, 255, 255, 0.8),
      ),
    );
  }
}
