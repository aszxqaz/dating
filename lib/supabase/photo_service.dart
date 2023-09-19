part of 'service.dart';

mixin _PhotoService on _BaseSupabaseService {
  Future<List<PhotoTable>?> findPhotosByUserId([String? userId]) async {
    final id = userId ?? globalUser?.id;
    if (id == null) return null;

    final photosJson = await supabaseClient
        .from('photos')
        .select<MapList>()
        .eq('user_id', id)
        .order('created_at', ascending: false);

    final photoTables = photosJson.map((json) => PhotoTable.fromJson(json));

    return photoTables.toList();
  }

  listenUpdates() {
    // final subscription =
    //     _client.from('photos').stream(primaryKey: ['id']).listen((event) {
    //   debugPrint('EVENTS: ' + event.toString());
    // });
  }
}
