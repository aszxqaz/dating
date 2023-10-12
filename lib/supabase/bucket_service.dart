part of 'service.dart';

mixin _BucketService on _BaseSupabaseService {
  Future<bool?> uploadPhoto({required Uint8List bytes}) async {
    return tryExecute('uploadPhoto', () async {
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
}
