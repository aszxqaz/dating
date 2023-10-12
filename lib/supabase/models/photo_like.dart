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

  Map<String, dynamic> toJson() => {
        'photo_id': photoId,
        'user_id': userId,
      };
}
