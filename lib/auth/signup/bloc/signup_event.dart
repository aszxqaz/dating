part of 'signup_bloc.dart';

@immutable
sealed class _SignUpEvent {
  const _SignUpEvent();
}

final class _InputSubmit extends _SignUpEvent {
  const _InputSubmit({
    required this.phone,
    required this.password,
    required this.confirmed,
  });

  final String phone;
  final String password;
  final String confirmed;
}

final class _VerificationSubmit extends _SignUpEvent {
  const _VerificationSubmit({required this.code});

  final String code;
}
