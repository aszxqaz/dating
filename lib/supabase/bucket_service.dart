part of 'service.dart';

mixin _BucketService on _SupabaseService {
  Future<bool?> uploadProfilePhoto({required Uint8List bytes}) async {
    return tryExecute('[BucketService] uploadProfilePhoto()', () async {
      final photoId = _uuid.v4();
      final path = '${globalUser!.id}/$photoId.jpg';
      await supabaseClient.storage.from('photos').uploadBinary(path, bytes);

      var link = supabaseClient.storage.from(globalUser!.id).getPublicUrl(path);

      if (globalUser!.id.allMatches(link).length > 1) {
        link = link.replaceFirst(globalUser!.id, 'photos');
      }

      await supabaseClient.from('photos').insert({
        'id': photoId,
        'user_id': globalUser!.id,
        'p_user_id': globalUser!.id,
        'link': link,
      });

      return true;
    });
  }

  Future<String?> uploadChatPhoto({
    required Uint8List bytes,
    required String receiverId,
  }) async {
    return tryExecute('[BucketService] uploadChatPhoto()', () async {
      final response = await uploadBinaryPhoto(bytes);

      if (response == null) {
        return null;
      }

      await supabaseClient.from('chat_photos').insert({
        'id': response.photoId,
        'sender_id': globalUser!.id,
        'receiver_id': receiverId,
        'url': response.url,
      });

      return response.photoId;
    });
  }

  Future<_UploadBinaryPhotoResponse?> uploadBinaryPhoto(Uint8List bytes) async {
    return tryExecute('[BucketService] uploadBinaryPhoto', () async {
      final photoId = _uuid.v4();
      final path = '${globalUser!.id}/$photoId.jpg';

      await supabaseClient.storage.from('photos').uploadBinary(path, bytes);

      var url = supabaseClient.storage.from(globalUser!.id).getPublicUrl(path);

      if (globalUser!.id.allMatches(url).length > 1) {
        url = url.replaceFirst(globalUser!.id, 'photos');
      }

      return _UploadBinaryPhotoResponse(url: url, photoId: photoId);
    });
  }
}

class _UploadBinaryPhotoResponse {
  const _UploadBinaryPhotoResponse({required this.url, required this.photoId});

  final String url;
  final String photoId;
}
