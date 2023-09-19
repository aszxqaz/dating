import 'dart:typed_data';

import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/models/location.dart';
import 'package:dating/supabase/models/model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'bucket_service.dart';
part 'photo_service.dart';
part 'profile_service.dart';
part 'location_service.dart';

class _BaseSupabaseService {
  _BaseSupabaseService();

  final _uuid = const Uuid();

  // User? get user => _client.auth.currentUser;
}

class SupabaseService extends _BaseSupabaseService
    with _BucketService, _PhotoService, _ProfileService, _LocationService {
  SupabaseService();
}

final supabaseService = SupabaseService();

typedef MapList = List<Map<String, dynamic>>;
typedef OptionalMap = Map<String, dynamic>?;
