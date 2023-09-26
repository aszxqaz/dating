import 'package:dating/chat/chat_message.dart';
import 'package:dating/chat/chat_message/element.dart';
import 'package:dating/chat/chat_message/split_into_chunks.dart';
import 'package:flutter/material.dart';

// extension ToChatMessageElements on ChatMessage {
//   List<ChatMessageElement> get chatMessageElements {
//     final textElements = text
//         .splitIntoChunks(emojis.map((e) => e.pos).toList())
//         .map(
//           (e) => e.lineBreak
//               ? LineBreakChatMessageElement(pos: e.start)
//               : TextChatMessageElement(pos: e.start, text: e.text),
//         )
//         .toList();

//     final emojiElements = emojis
//         .map((e) => EmojiChatMessageWidget(pos: e.pos, emoji: e))
//         .toList();

//     final res = textElements + emojiElements;

//     res.sort((a, b) {
//       final cmp = a.pos.compareTo(b.pos);
//       if (cmp != 0) return cmp;
//       if (a is EmojiChatMessageWidget) {
//         return -1;
//       } else {
//         return 1;
//       }
//     });

//     debugPrint('Chat message elements:');
//     for (final el in res) {
//       debugPrint(el.toString());
//     }

//     return res;
//   }
// }
