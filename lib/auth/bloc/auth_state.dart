part of 'auth_bloc.dart';

enum AuthScreen { signin, signup }

@immutable
class AuthState {
  const AuthState({
    required this.screen,
    this.countryCode,
    this.authenticated = false,
    this.profile,
  });

  final AuthScreen screen;
  final String? countryCode;
  final bool authenticated;
  final Profile? profile;

  _toScreen(AuthScreen screen) => AuthState(
        screen: screen,
        countryCode: countryCode,
      );

  toSignIn() => _toScreen(AuthScreen.signin);
  toSignUp() => _toScreen(AuthScreen.signup);
  toAuthenticated(Profile? profile) => AuthState(
        screen: screen,
        countryCode: countryCode,
        authenticated: true,
        profile: profile,
      );

  bool get isSignIn => screen == AuthScreen.signin;
  bool get isSignUp => screen == AuthScreen.signup;
}
