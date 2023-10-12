part of 'service.dart';

mixin _PhotoService on _BaseSupabaseService {
  Future<List<Photo>?> photosByUserId([String? userId]) async {
    final id = userId ?? globalUser?.id;
    if (id == null) return null;

    try {
      final photosJson = await supabaseClient
          .from('photos')
          .select<List<Map<String, dynamic>>>('''
            id,
            link,
            created_at,
            photo_likes (*)
          ''')
          .eq('user_id', id)
          .order('created_at');

      final photos = photosJson.map((json) => Photo.fromJson(json)).toList();

      return photos;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool?> deletePhoto(String photoId) async {
    return tryExecute('deletePhoto', () async {
      await supabaseClient.from('photos').delete().eq('id', photoId);
      return true;
    });
  }

  Future<bool?> likePhoto(String photoId, String profileId) async {
    return tryExecute('likePhoto', () async {
      await supabaseClient.from('photo_likes').insert({
        'photo_id': photoId,
        'user_id': requireUserId,
        'profile_id': profileId,
      });
      return true;
    });
  }

  Future<bool?> unlikePhoto(String photoId) async {
    return tryExecute('dislikePhoto', () async {
      await supabaseClient
          .from('photo_likes')
          .delete()
          .eq('photo_id', photoId)
          .eq('user_id', requireUserId);
      return true;
    });
  }
}
