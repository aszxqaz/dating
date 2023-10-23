part of 'service.dart';

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

@immutable
final class AuthResponse {
  const AuthResponse({this.error, required this.ok});

  final String? error;
  final bool? ok;
}

mixin _AuthService on _BaseSupabaseService {
  void signOut() {
    supabaseClient.auth.signOut();
  }

  Future<AuthResponse?> signUp({
    required String phone,
    required String password,
  }) async {
    return tryExecute('signUp', () async {
      final response = await supabaseClient.auth.signUp(
        phone: phone,
        password: password,
      );

      if (response.user?.identities?.isEmpty == true) {
        return const AuthResponse(ok: false, error: 'Some error occured');
      }

      return const AuthResponse(ok: true);
    }, false);
  }

  Future<bool?> verifyCode({
    required String phone,
    required String code,
  }) async {
    return tryExecute('verifyCode', () async {
      final response = await supabaseClient.auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: code,
      );

      if (response.user == null) {
        return null;
      }

      // Profile? profile = await supabaseService.fetchProfile(response.user!.id);

      // profile ??= await supabaseClient
      //     .from('profiles')
      //     .insert({'id': response.user!.id}).select<Map<();

      return true;
    }, false);
  }

  Future<bool?> requestOtp({required String phone}) async {
    return tryExecute('requestOtp', () async {
      await supabaseClient.auth.signInWithOtp(
        phone: phone,
        shouldCreateUser: false,
      );
      return true;
    }, false);
  }

  Future<bool?> signInWithPassword({
    required String phone,
    required String password,
    bool isEmail = false,
  }) async {
    return tryExecute('signInWithPassword', () async {
      await supabaseClient.auth.signInWithPassword(
        phone: phone,
        password: password,
      );

      return true;
    }, false);

    // } on AuthException catch (_) {
  }

  Future<bool?> signInWithFacebook() async {
    return tryExecute('signInWithFacebook', () async {
      return await supabaseClient.auth.signInWithOAuth(
        Provider.facebook,
        // authScreenLaunchMode: LaunchMode.inAppWebView,
        redirectTo: 'io.supabase.flutterdemo://login-callback',
        // context: context,
      );
    }, false);
  }

  Future<void> signInWithGoogle2(BuildContext context) async {
    await supabaseClient.auth.signInWithOAuth(
      Provider.google,
      authScreenLaunchMode: LaunchMode.inAppWebView,
      redirectTo: 'io.supabase.flutterdemo://login-callback',
      context: context,
    );
  }

  Future<bool?> signInWithGoogle() async {
    return tryExecute('signInWithGoogle', () async {
      const appAuth = FlutterAppAuth();

      final random = Random.secure();
      final rawNonce =
          base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final clientId = dotenv.env['GOOGLE_CLIENT_ID']!;

      final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

      const discoveryUrl =
          'https://accounts.google.com/.well-known/openid-configuration';

      // authorize the user by opening the concent page
      final result = await appAuth.authorize(
        AuthorizationRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          nonce: hashedNonce,
          scopes: [
            'openid',
            'email',
          ],
        ),
      );

      if (result == null) {
        throw 'No result';
      }

      // Request the access and id token to google
      final tokenResult = await appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          authorizationCode: result.authorizationCode,
          discoveryUrl: discoveryUrl,
          codeVerifier: result.codeVerifier,
          nonce: result.nonce,
          scopes: [
            'openid',
            'email',
          ],
        ),
      );

      final idToken = tokenResult?.idToken;

      if (idToken == null) {
        throw 'No idToken';
      }

      final authResponse = await supabaseClient.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        nonce: rawNonce,
        accessToken: tokenResult?.accessToken,
      );

      return authResponse.user != null;
    }, false);
  }
}

extension ToUser on AuthState {
  AppUser? toUser() {
    if (session == null) return null;
    return AppUser(id: session!.user.id);
  }
}
