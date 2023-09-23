class Photo {
  const Photo({
    required this.id,
    required this.userId,
    required this.url,
    required this.uploadedAt,
    required this.likes,
  });

  final String id;
  final String userId;
  final String url;
  final DateTime uploadedAt;
  final Iterable<PhotoLike> likes;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json['id'],
        userId: json['user_id'],
        url: json['link'],
        uploadedAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
        likes: json['photo_likes'] != null
            ? (json['photo_likes'] as List)
                .map((like) => PhotoLike.fromJson(like))
            : [],
      );

  @override
  toString() => 'Photo (id: *, userId: *, link: $url, likes: $likes.length)';
}

class PhotoLike {
  const PhotoLike({
    required this.photoId,
    required this.userId,
  });

  final String photoId;
  final String userId;

  factory PhotoLike.fromJson(Map<String, dynamic> json) => PhotoLike(
        photoId: json['photo_id'],
        userId: json['user_id'],
      );
}
