import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:dating/chat/photo_uploader_bloc/photo_uploader_bloc.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/supabase/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

export 'models/models.dart';

part 'auth_service.dart';
part 'bucket_service.dart';
part 'channel_service.dart';
part 'chat_service.dart';
part 'location_service.dart';
part 'notification_service.dart';
part 'photo_service.dart';
part 'user_service.dart';
part 'feed_service.dart';
part 'profile_service.dart';
part 'typedef.dart';

class _SupabaseService {
  _SupabaseService();

  final _uuid = const Uuid();

  bool get hasNoUserId => globalUser == null;
  String get requireUserId => globalUser!.id;

  Stream<AuthState> get authChange => supabaseClient.auth.onAuthStateChange;

  FutureOr<T?> tryExecute<T>(
      String description, FutureOr<T?> Function() function,
      [bool checkUser = true]) async {
    if (hasNoUserId && checkUser) return null;

    try {
      final result = await function();
      return result;
    } catch (e) {
      debugPrint('$description: \n$e');
      return null;
    }
  }
}

class _BaseSupabaseService extends _SupabaseService
    with _ProfileService, _ChannelService, _BucketService {}

class SupabaseService extends _BaseSupabaseService
    with
        _AuthService,
        _FeedService,
        _PhotoService,
        _LocationService,
        _UserService,
        _NotificationService,
        _ChatService {
  SupabaseService();
}

final supabaseService = SupabaseService();
