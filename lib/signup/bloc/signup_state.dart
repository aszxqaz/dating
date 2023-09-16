part of 'signup_bloc.dart';

@immutable
sealed class SignUpState {
  const SignUpState({
    this.error,
    this.loading = false,
  });

  final String? error;
  final bool loading;
}

final class SignUpInputState extends SignUpState {
  const SignUpInputState({
    required Phone phone,
    required Password password,
    required ConfirmedPassword confirmed,
    String? error,
    bool loading = false,
  })  : _confirmed = confirmed,
        _password = password,
        _phone = phone,
        super(
          error: error,
          loading: loading,
        );

  factory SignUpInputState.initial() => const SignUpInputState(
        phone: Phone.pure(),
        password: Password.pure(),
        confirmed: ConfirmedPassword.pure(),
      );

  final Phone _phone;
  final Password _password;
  final ConfirmedPassword _confirmed;

  String get phone => _phone.value;
  String get password => _password.value;
  String get confirmed => _confirmed.value;

  SignUpInputState copyWith({
    Phone? phone,
    Password? password,
    ConfirmedPassword? confirmed,
    String? error,
    bool? loading,
  }) =>
      SignUpInputState(
        phone: phone ?? _phone,
        password: password ?? _password,
        confirmed: confirmed ?? _confirmed,
        error: error ?? this.error,
        loading: loading ?? this.loading,
      );
}

final class SignUpVerifyState extends SignUpState {
  const SignUpVerifyState({
    required this.code,
    String? error,
    bool loading = false,
  }) : super(
          error: error,
          loading: loading,
        );

  factory SignUpVerifyState.initial() => const SignUpVerifyState(code: '');

  final String code;

  SignUpVerifyState copyWith({
    String? code,
    String? error,
    bool? loading,
  }) =>
      SignUpVerifyState(
        code: code ?? this.code,
        error: error ?? this.error,
        loading: loading ?? this.loading,
      );
}
