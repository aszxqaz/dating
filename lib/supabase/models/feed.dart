part of 'models.dart';

class FeedChannelModel extends Identifiable {
  FeedChannelModel({
    String? id,
    required this.senderId,
    required this.photoId,
    required this.status,
    required this.createdAt,
  }) : super(id: id);

  factory FeedChannelModel.fromJson(PostgrestMap json) => FeedChannelModel(
        id: json['id'],
        senderId: json['sender_id'],
        photoId: json['photo_id'],
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
      );

  final String senderId;
  final DateTime createdAt;
  final String? photoId;
  final String? status;

  @override
  toString() =>
      'FeedChannelModel (senderId: $senderId, photoId: $photoId, status: $status)';
}

class Feed extends FeedChannelModel {
  Feed({
    required super.id,
    required super.senderId,
    required super.photoId,
    required super.status,
    required super.createdAt,
    required this.photo,
  });

  final Photo? photo;

  factory Feed.fromFeedChannelModel(FeedChannelModel model, Photo? photo) =>
      Feed(
        id: model.id,
        senderId: model.senderId,
        photoId: model.photoId,
        status: model.status,
        createdAt: model.createdAt,
        photo: photo,
      );
}
