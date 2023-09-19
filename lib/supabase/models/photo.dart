class Photo {
  const Photo({
    required this.id,
    required this.userId,
    required this.url,
    required this.uploadedAt,
  });

  final String id;
  final String userId;
  final String url;
  final DateTime uploadedAt;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json['id'],
        userId: json['user_id'],
        url: json['link'],
        uploadedAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      );

  @override
  toString() => 'Photo (id: *, userId: *, link: $url)';
}
