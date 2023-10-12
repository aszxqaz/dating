part of 'models.dart';

class Photo {
  const Photo({
    required this.id,
    required this.url,
    required this.uploadedAt,
    required this.likes,
  });

  final String id;
  final String url;
  final DateTime uploadedAt;
  final List<String> likes;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json['id'],
        url: json['link'],
        uploadedAt:
            DateTime.tryParse(json['created_at'])?.toLocal() ?? DateTime.now(),
        likes: json['photo_likes'] != null
            ? (json['photo_likes'] as List)
                .map((like) => like['user_id'] as String)
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'link': url,
        'created_at': uploadedAt.toIso8601String(),
        'photo_likes': likes,
      };

  @override
  toString() => 'Photo (id: *, userId: *, link: $url, likes: $likes.length)';

  // ---
  // --- SPECIFIC
  // ---

  Photo liked(String userId) {
    final newLikes = likes.upsertWhere(userId, (id) => id == userId, true);
    return Photo(
      id: id,
      uploadedAt: uploadedAt,
      url: url,
      likes: newLikes,
    );
  }

  Photo unliked(String userId) {
    final newLikes = likes.where((id) => id != userId).toList();
    return Photo(
      id: id,
      uploadedAt: uploadedAt,
      url: url,
      likes: newLikes,
    );
  }
}
