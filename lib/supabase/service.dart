import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dating/chat/chat_view.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/models/chat.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

export 'models/models.dart';

part 'bucket_service.dart';
part 'chat_service.dart';
part 'location_service.dart';
part 'photo_service.dart';
part 'preference_service.dart';
part 'profile_service.dart';

class _BaseSupabaseService {
  _BaseSupabaseService();

  final _uuid = const Uuid();

  // User? get user => _client.auth.currentUser;
}

class SupabaseService extends _BaseSupabaseService
    with
        _BucketService,
        _PhotoService,
        _ProfileService,
        _LocationService,
        _PreferenceService,
        _ChatService {
  SupabaseService();
}

final supabaseService = SupabaseService();

typedef MapList = List<Map<String, dynamic>>;
typedef OptionalMap = Map<String, dynamic>?;
