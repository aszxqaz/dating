import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/supabase/models/notification.dart';
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
part 'notification_service.dart';
part 'typedef.dart';
part 'channel_service.dart';

class _SupabaseService {
  _SupabaseService();

  final _uuid = const Uuid();

  bool get hasNoUserId => globalUser == null;
  String get requireUserId => globalUser!.id;

  FutureOr<T?> tryExecute<T>(
      String description, FutureOr<T> Function() function) async {
    if (hasNoUserId) return null;

    try {
      final result = await function();
      return result;
    } catch (e) {
      debugPrint('SUPABASE_SERVICE [ERROR]: $description: \n$e');
      return null;
    }
  }
}

class _BaseSupabaseService extends _SupabaseService
    with _ProfileService, _ChannelService {}

class SupabaseService extends _BaseSupabaseService
    with
        _BucketService,
        _PhotoService,
        _LocationService,
        _PreferenceService,
        _NotificationService,
        _ChatService {
  SupabaseService();
}

final supabaseService = SupabaseService();
