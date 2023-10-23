part of '../chat_view.dart';

const photoUrlPlaceholder = '';

class _BottomControls extends StatefulWidget {
  const _BottomControls({
    required this.onMessageSendPressed,
  });

  final void Function(String, List<PhotoUploaderItem>?) onMessageSendPressed;

  @override
  State<_BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<_BottomControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MainPanel(),
        const _PhotoUploaderPanel(),
        ValueListenableBuilder(
          valueListenable: isEmojiShown,
          builder: (_, emojiShowing, child) {
            return Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                height: 250,
                child: child,
              ),
            );
          },
          child: _EmojiPicker(
            controller: controller,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
