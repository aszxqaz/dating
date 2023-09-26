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
