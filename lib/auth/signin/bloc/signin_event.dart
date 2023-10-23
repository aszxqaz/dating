part of 'signin_bloc.dart';

@immutable
sealed class _SignInEvent {
  const _SignInEvent();
}

final class _OtpRequested extends _SignInEvent {
  const _OtpRequested({required this.phone});

  final String phone;
}

final class _OtpVerified extends _SignInEvent {
  const _OtpVerified({required this.code});

  final String code;
}

final class _PasswordSubmit extends _SignInEvent {
  const _PasswordSubmit({
    required this.phone,
    required this.password,
  });

  final String phone;
  final String password;
}

final class _MethodSwitched extends _SignInEvent {
  const _MethodSwitched({required this.toPassword});

  final bool toPassword;
}
