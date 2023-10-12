import 'dart:async';

import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/user.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationError {
  const AuthenticationError(this.message);
  final String message;
}

final class OccupiedAuthenticationError extends AuthenticationError {
  const OccupiedAuthenticationError()
      : super('Phone number already registered');
}

final class BadCredentialsAuthenticationError extends AuthenticationError {
  const BadCredentialsAuthenticationError()
      : super('Wrong phone number or password');
}

final class UnknownAuthenticationError extends AuthenticationError {
  const UnknownAuthenticationError() : super('Unknown error occured');
}

class AuthService {
  const AuthService();
  // : supabaseClient = supabaseClient;

  // final SupabaseClient supabaseClient;

  // Stream<AppUser?> get user {
  //   return supabaseClient.auth.onAuthStateChange.map((auth) {
  //     final user = auth.toUser();
  //     return user;
  //   });
  // }

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  void signOut() {
    supabaseClient.auth.signOut();
  }

  Future<void> signUp({
    String? phone,
    String? email,
    required String password,
    required String birthdate,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        phone: phone,
        email: email,
        password: password,
      );

      if (response.user?.identities?.isEmpty == true) {
        throw const OccupiedAuthenticationError();
      }

      // final session = response.session as Session;
      // final user = response.user as User;

      // final profile = await supabaseClient
      //     .from('profiles')
      //     .select()
      //     .eq('user_id', user.id)
      //     .maybeSingle();

      // if (profile == null) {
      //   await supabaseClient.from('profiles').insert({
      //     'user_id': user.id,
      //     'birthdate': birthdate,
      //   });
      //   debugPrint('SIGN UP: NEW PROFILE REGISTERED');
      // }
    } on AuthException catch (err) {
      throw AuthenticationError(err.message);
    } on AuthenticationError catch (_) {
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> verifyCode({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await supabaseClient.auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: code,
      );

      if (response.user == null) {
        throw Exception('User not found');
      }

      final user = await supabaseClient
          .from('profiles')
          .select<Map<String, dynamic>?>('id')
          .eq('id', response.user!.id)
          .maybeSingle();

      if (user == null) {
        await supabaseClient.from('profiles').insert({'id': response.user!.id});
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> signInWithPhone({required String phone}) async {
    try {
      await supabaseClient.auth.signInWithOtp(
        phone: phone,
      );
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
  }

  Future<AuthenticationError?> signInWithPassword({
    required String phoneOrEmail,
    required String password,
    bool isEmail = false,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: isEmail ? phoneOrEmail : null,
        phone: isEmail ? null : phoneOrEmail,
        password: password,
      );

      final data = await supabaseClient
          .from('profiles')
          .select<Map<String, dynamic>?>()
          .eq('user_id', response.user!.id)
          .maybeSingle();

      debugPrint(data.toString());
      debugPrint(response.user!.id);
      return null;
    } on AuthException catch (_) {
      return const BadCredentialsAuthenticationError();
    } catch (e) {
      debugPrint(e.toString());
      return const UnknownAuthenticationError();
    }
  }
}

extension ToUser on AuthState {
  AppUser? toUser() {
    if (session == null) return null;
    return AppUser(id: session!.user.id);
  }
}

const authService = AuthService();
