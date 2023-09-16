part of 'password_bloc.dart';

@immutable
sealed class PasswordSignInEvent {
  const PasswordSignInEvent();
}

final class PasswordSignInInputChanged extends PasswordSignInEvent {
  const PasswordSignInInputChanged({
    this.phone,
    this.password,
  });

  final String? phone;
  final String? password;
}

final class PasswordSignInSubmit extends PasswordSignInEvent {
  const PasswordSignInSubmit();
}

final class PasswordSignInVerifySubmit extends PasswordSignInEvent {
  const PasswordSignInVerifySubmit();
}
