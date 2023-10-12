import 'package:dating/misc/extensions.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiTextField extends StatefulWidget {
  const EmojiTextField({
    super.key,
    required this.onMessageSendPressed,
  });

  final void Function(String) onMessageSendPressed;

  @override
  State<EmojiTextField> createState() => _EmojiTextFieldState();
}

class _EmojiTextFieldState extends State<EmojiTextField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool emojiShowing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _onBackspacePressed() {
    controller
      ..text = controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.colorScheme.primary,
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      emojiShowing = !emojiShowing;
                    });
                  },
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: Colors.white,
                      // contentPadding: const EdgeInsets.only(
                      //   left: 8.0,
                      //   bottom: 0.0,
                      //   top: 0.0,
                      //   right: 8.0,
                      // ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(50.0),
                      // ),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    widget.onMessageSendPressed(controller.text);
                    controller.text = '';
                    focusNode.requestFocus();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        Offstage(
          offstage: !emojiShowing,
          child: SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (_, __) {
                focusNode.requestFocus();
              },
              textEditingController: controller,
              onBackspacePressed: _onBackspacePressed,
              config: Config(
                columns: 7,
                // Issue: https://github.com/flutter/flutter/issues/28894
                emojiSizeMax: 32 *
                    (foundation.defaultTargetPlatform == TargetPlatform.iOS
                        ? 1.30
                        : 1.0),
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
            ),
          ),
        ),
      ],
    );
  }
}
