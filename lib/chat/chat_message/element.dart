import 'package:dating/chat/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class ChatMessageElement {
  ChatMessageElement(this.pos);

  final int pos;

  InlineSpan build();
}

class EmojiChatMessageWidget extends ChatMessageElement {
  EmojiChatMessageWidget({
    required int pos,
    required this.emoji,
  }) : super(pos);

  final Emoji emoji;

  @override
  WidgetSpan build() {
    return WidgetSpan(
      child: SvgPicture.asset(
        'assets/emoji/noto/noto${emoji.kind}.svg',
        width: 20,
        height: 20,
      ),
    );
  }

  @override
  toString() {
    return 'EmojiChatMessageWidget (pos: $pos)';
  }
}

class TextChatMessageElement extends ChatMessageElement {
  TextChatMessageElement({
    required int pos,
    required this.text,
  }) : super(pos);

  final String text;

  @override
  TextSpan build() {
    return TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  toString() {
    return 'TextChatMessageElement (pos: $pos, text: $text)';
  }
}

class LineBreakChatMessageElement extends ChatMessageElement {
  LineBreakChatMessageElement({
    required int pos,
  }) : super(pos);

  @override
  TextSpan build() {
    return const TextSpan(
      text: '\n',
    );
  }

  @override
  toString() {
    return 'LineBreakChatMessageElement (pos: $pos)';
  }
}
