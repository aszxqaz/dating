import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dating/chat/chat_message.dart';
import 'package:dating/chat/chat_message/converter.dart';
import 'package:dating/misc/extensions.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          child: Text.rich(
            TextSpan(
                children:
                    message.chatMessageElements.map((e) => e.build()).toList()

                // children: chunks.fold(
                //   <InlineSpan>[],
                //   (children, chunk) {
                //     debugPrint('chunkkkkkk end ' + chunk.end.toString());

                //     final emojis = message.emojis.where((emoji) =>
                //         emoji.pos >= chunk.start && emoji.pos < chunk.end);

                //     List<InlineSpan> widgets = [];
                //     int lastEmojiPos = 0;

                //     for (final emoji in emojis) {
                //       if (emoji.pos < chunk.end) {
                //         final sub = chunk.text
                //             .substring(lastEmojiPos, emoji.pos - chunk.start);

                //         widgets.add(
                //             TextChatMessageElement(pos: 0, text: sub).build());
                //         widgets.add(EmojiChatMessageElement(pos: 0, emoji: emoji)
                //             .build());

                //         lastEmojiPos = emoji.pos - chunk.start;
                //       } else {
                //         widgets.add(const TextSpan(text: '\n'));
                //         widgets.add(EmojiChatMessageElement(pos: 0, emoji: emoji)
                //             .build());
                //       }
                //     }

                //     final sub = chunk.text
                //         .substring(lastEmojiPos, chunk.end - chunk.start);

                //     if (sub.isNotEmpty) {
                //       widgets
                //           .add(TextChatMessageElement(pos: 0, text: sub).build());
                //     }

                //     debugPrint('chunks text len ' + chunksTextLen.toString());
                //     debugPrint('chunk end' + chunk.end.toString());

                //     return [
                //       ...children!,
                //       ...widgets,
                //       if (chunk.end != chunksTextLen &&
                //           lastEmojiPos + 1 != chunksTextLen)
                //         const TextSpan(text: '\n'),
                //     ];
                //   },
                // ),
                ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
