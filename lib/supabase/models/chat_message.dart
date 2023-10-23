part of 'models.dart';

class ChatMessage extends Identifiable {
  ChatMessage({
    super.id,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.read = false,
    this.incoming = false,
    this.sent = false,
    DateTime? createdAt,
    this.photos,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    required bool incoming,
  }) {
    List<ChatMessagePhoto>? photos;
    if (json['photos_json'] != null) {
      photos = List.castFrom<dynamic, Map<String, dynamic>>(json['photos_json'])
          .map(ChatMessagePhoto.fromJson)
          .toList();
    }

    return ChatMessage(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      text: json['text'],
      read: json['read'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      incoming: incoming,
      sent: true,
      photos: photos,
    );
  }

  final String senderId;
  final String receiverId;
  final List<ChatMessagePhoto>? photos;
  final String? text;
  final DateTime createdAt;
  final bool read;
  final bool sent;
  final bool incoming;

  List<String> get requireUrls => photos!.map((photo) => photo.url!).toList();
  List<Uint8List> get requireBytes =>
      photos!.map((photo) => photo.bytes!).toList();

  ChatMessage copyWith({
    String? text,
    List<ChatMessagePhoto>? photos,
    DateTime? createdAt,
    bool? read,
    bool? sent,
  }) =>
      ChatMessage(
        id: id,
        senderId: senderId,
        receiverId: receiverId,
        incoming: incoming,
        photos: photos ?? this.photos,
        text: text ?? this.text,
        read: read ?? this.read,
        sent: sent ?? this.sent,
        createdAt: createdAt ?? this.createdAt,
      );
}

enum ChatMessageType {
  text,
  photo;

  static ChatMessageType fromString(String name) {
    for (final value in ChatMessageType.values) {
      if (value.name == name) return value;
    }

    throw Exception('No ChatMessageType for "$name" found');
  }
}

class ChatMessagePhoto extends Identifiable {
  ChatMessagePhoto({
    super.id,
    required this.blurHash,
    required this.width,
    required this.height,
    this.url,
    this.bytes,
    this.uploading = UploadingStatus.none,
    this.blurBytes,
  });

  final String? url;
  final String blurHash;
  final int width;
  final int height;
  final Uint8List? blurBytes;

  // Uploading
  final Uint8List? bytes;
  final UploadingStatus uploading;

  factory ChatMessagePhoto.fromUpload(PhotoUploaderItem item) {
    return ChatMessagePhoto(
      id: item.id,
      uploading: UploadingStatus.waiting,
      bytes: item.bytes,
      blurHash: item.blurHash!,
      width: item.width!,
      height: item.height!,
    );
  }

  factory ChatMessagePhoto.fromJson(Map<String, dynamic> json) {
    return ChatMessagePhoto(
      id: json['i'],
      blurHash: json['b'],
      url: json['u'],
      width: json['w'],
      height: json['h'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'i': id,
      'b': blurHash,
      'u': url,
      'w': width,
      'h': height,
    };
  }

  ChatMessagePhoto copyWith({
    String? url,
    String? blurHash,
    int? width,
    int? height,
    Uint8List? bytes,
    UploadingStatus? uploading,
    Uint8List? blurBytes,
  }) =>
      ChatMessagePhoto(
        id: id,
        url: url ?? this.url,
        blurHash: blurHash ?? this.blurHash,
        width: width ?? this.width,
        height: height ?? this.height,
        bytes: bytes ?? this.bytes,
        blurBytes: blurBytes ?? this.blurBytes,
        uploading: uploading ?? this.uploading,
      );

  bool get isUploading => uploading == UploadingStatus.waiting;
  bool get isUploaded => uploading == UploadingStatus.done;

  ChatMessagePhoto get uploaded => copyWith(uploading: UploadingStatus.done);

  @override
  toString() =>
      'Photo (url: $url, bytes length: ${bytes?.length}, uploading: ${uploading.name})';
}

enum UploadingStatus {
  none,
  waiting,
  done,
}
