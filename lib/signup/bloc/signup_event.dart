part of 'signup_bloc.dart';

@immutable
sealed class SignUpEvent {
  const SignUpEvent();
}

final class SignUpInputChanged extends SignUpEvent {
  const SignUpInputChanged({
    this.phone,
    this.password,
    this.confirmed,
  });
  final Phone? phone;
  final Password? password;
  final ConfirmedPassword? confirmed;
}

final class SignUpCodeChanged extends SignUpEvent {
  const SignUpCodeChanged({
    required this.code,
  });
  final String code;
}

final class SignUpSubmitEvent extends SignUpEvent {
  const SignUpSubmitEvent();
}

final class SignUpVerifyEvent extends SignUpEvent {
  const SignUpVerifyEvent();
}
