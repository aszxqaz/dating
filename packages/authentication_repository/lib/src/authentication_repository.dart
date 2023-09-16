import 'dart:async';
import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:meta/meta.dart';
import 'package:supabase/supabase.dart' hide User;

class AuthenticationRepositorySignUpError {
  const AuthenticationRepositorySignUpError(this.message);
  final String message;
}

final class PhoneAlreadyRegistered extends AuthenticationRepositorySignUpError {
  const PhoneAlreadyRegistered() : super('Phone number already registered');
}

class AuthRepository {
  AuthRepository({
    required SupabaseClient supabaseClient,
    CacheClient? cache,
  })  : _cache = cache ?? CacheClient(),
        _supabaseClient = supabaseClient;

  final CacheClient _cache;
  final SupabaseClient _supabaseClient;

  Stream<User?> get user {
    return _supabaseClient.auth.onAuthStateChange.map((auth) {
      final user = auth.toUser();
      // _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  void signOut() {
    _supabaseClient.auth.signOut();
  }

  Future<void> signUp({
    required String phone,
    required String password,
  }) async {
    print("password: $password");
    print("phone: $phone");
    try {
      // final user = await _supabaseClient
      //     .from('auth.users')
      //     .select<Map<String, dynamic>?>('id')
      //     .eq('phone', phone.substring(1))
      //     .maybeSingle();

      // if (user != null) {
      //   throw PhoneAlreadyRegistered();
      // }

      final response = await _supabaseClient.auth.signUp(
        phone: phone,
        password: password,
      );

      print(response.user?.toJson().toString());

      if (response.user?.identities?.isEmpty == true) {
        throw PhoneAlreadyRegistered();
      }
    } on AuthException catch (err) {
      throw AuthenticationRepositorySignUpError(err.message);
    } on AuthenticationRepositorySignUpError catch (err) {
      throw err;
    } catch (err) {
      throw AuthenticationRepositorySignUpError('Unknown error occured');
    }
  }

  Future<void> verifyCode({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _supabaseClient.auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: code,
      );

      if (response.user == null) {
        throw Exception('User not found');
      }

      final user = await _supabaseClient
          .from('profiles')
          .select<Map<String, dynamic>?>('id')
          .eq('id', response.user!.id)
          .maybeSingle();

      if (user == null) {
        await _supabaseClient
            .from('profiles')
            .insert({'id': response.user!.id});
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> signInWithPhone({required String phone}) async {
    try {
      await _supabaseClient.auth.signInWithOtp(
        phone: phone,
      );
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future<void> signInWithPassword({
    required String phoneOrEmail,
    required String password,
    bool isEmail = false,
  }) async {
    try {
      await _supabaseClient.auth.signInWithPassword(
        email: isEmail ? phoneOrEmail : null,
        phone: isEmail ? null : phoneOrEmail,
        password: password,
      );
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }
}

extension ToUser on AuthState {
  User? toUser() {
    if (session == null) return null;
    return User(id: session!.user.id);
  }
}
