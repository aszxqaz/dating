part of 'password_bloc.dart';

@immutable
sealed class PasswordSignInState {
  const PasswordSignInState();
}

final class PasswordSignInInputState extends PasswordSignInState {
  const PasswordSignInInputState({
    required this.phone,
    required this.password,
  });

  factory PasswordSignInInputState.initial() => const PasswordSignInInputState(
        phone: '',
        password: '',
      );

  final String phone;
  final String password;

  PasswordSignInInputState copyWith({
    String? phone,
    String? password,
  }) {
    return PasswordSignInInputState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}

final class PasswordSignInLoadingState extends PasswordSignInState {
  const PasswordSignInLoadingState();
}

final class PasswordSignInErrorState extends PasswordSignInState {
  const PasswordSignInErrorState({
    required this.error,
  });

  final Object error;
}

final class PasswordSignInSuccessState extends PasswordSignInState {
  const PasswordSignInSuccessState();
}
