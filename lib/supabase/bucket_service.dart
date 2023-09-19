part of 'service.dart';

mixin _BucketService on _BaseSupabaseService {
  Future<void> uploadPhoto({
    required Uint8List bytes,
  }) async {
    if (globalUser == null) return;
    final photoId = _uuid.v4();
    final path = '${globalUser!.id}/$photoId.jpg';

    try {
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createBucket() async {
    if (globalUser == null) return;

    await supabaseClient.storage
        .createBucket(globalUser!.id, const BucketOptions(public: true));
  }
}
