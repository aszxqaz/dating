part of 'auth_bloc.dart';

sealed class _AuthEvent {
  const _AuthEvent();
}

class _GoToSignIn extends _AuthEvent {
  const _GoToSignIn();
}

class _GoToSignUp extends _AuthEvent {
  const _GoToSignUp();
}

class _Authenticated extends _AuthEvent {
  const _Authenticated({required this.profile});

  final Profile? profile;
}

final class _SignInWithGoogle extends _AuthEvent {
  const _SignInWithGoogle();
}

final class _SignInWithFacebook extends _AuthEvent {
  const _SignInWithFacebook();
}
