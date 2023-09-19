part of 'password_bloc.dart';

@immutable
sealed class PasswordSignInState {
  const PasswordSignInState({
    this.error,
    this.loading = false,
  });

  final String? error;
  final bool loading;
}

final class PasswordSignInInputState extends PasswordSignInState {
  const PasswordSignInInputState({
    required this.phone,
    required this.password,
    String? error,
    bool loading = false,
  }) : super(
          error: error,
          loading: loading,
        );

  static const initial = PasswordSignInInputState(
    phone: Phone.initial,
    password: Password.initial,
  );

  final Phone phone;
  final Password password;

  PasswordSignInInputState copyWith({
    Phone? phone,
    Password? password,
    String? error,
    bool? loading,
  }) =>
      PasswordSignInInputState(
        phone: phone ?? this.phone,
        password: password ?? this.password,
        error: error ?? this.error,
        loading: loading ?? this.loading,
      );
}
