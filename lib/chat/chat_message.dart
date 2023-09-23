class Emoji {
  const Emoji({
    required this.pos,
    required this.kind,
  });

  final int pos;
  final int kind;

  factory Emoji.fromJson(Map<String, dynamic> json) => Emoji(
        pos: json['pos'] as int,
        kind: json['kind'] as int,
      );
}

class ChatMessage {
  const ChatMessage({required this.text, required this.emojis});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        emojis: (json['emojis'] as List).map(
          (emoji) => Emoji.fromJson(emoji),
        ),
      );

  final String text;
  final Iterable<Emoji> emojis;
}
