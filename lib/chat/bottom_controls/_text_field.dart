part of '../chat_view.dart';

class _EmojiTextField extends StatelessWidget {
  const _EmojiTextField({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      minLines: 1,
      maxLines: 5,
      style: const TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: 'Type a message',
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white70,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}

class _EmojiPicker extends StatelessWidget {
  const _EmojiPicker({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  _onBackspacePressed() {
    controller
      ..text = controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      onEmojiSelected: (_, __) {
        focusNode.requestFocus();
      },
      textEditingController: controller,
      onBackspacePressed: _onBackspacePressed,
      config: Config(
        columns: 7,
        // Issue: https://github.com/flutter/flutter/issues/28894
        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: const Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        recentTabBehavior: RecentTabBehavior.RECENT,
        recentsLimit: 28,
        replaceEmojiOnLimitExceed: false,
        noRecents: const Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
        loadingIndicator: const SizedBox.shrink(),
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
        checkPlatformCompatibility: true,
      ),
    );
  }
}
