part of 'signup_bloc.dart';

enum SignUpOption { phone, email, both }

extension IsOption on SignUpOption {
  bool get isPhone => this == SignUpOption.phone;
  bool get isEmail => this == SignUpOption.email;
  bool get isPhoneOrBoth =>
      this == SignUpOption.phone || this == SignUpOption.both;
  bool get isEmailOrBoth =>
      this == SignUpOption.email || this == SignUpOption.both;
  bool get isBoth => this == SignUpOption.both;
}

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
    required this.option,
    required this.phone,
    required this.email,
    required this.password,
    required this.birthdate,
    required this.confirmed,
    String? error,
    bool loading = false,
  }) : super(
          error: error,
          loading: loading,
        );

  factory SignUpInputState.initial() => const SignUpInputState(
        option: SignUpOption.phone,
        phone: Phone.initial,
        email: Email.initial,
        birthdate: Birthdate.initial,
        password: Password.initial,
        confirmed: ConfirmedPassword.pure(),
      );

  final SignUpOption option;
  final Phone phone;
  final Email email;
  final Birthdate birthdate;
  final Password password;
  final ConfirmedPassword confirmed;

  SignUpInputState copyWith({
    SignUpOption? option,
    Phone? phone,
    Email? email,
    Birthdate? birthdate,
    Password? password,
    ConfirmedPassword? confirmed,
    String? error,
    bool? loading,
  }) =>
      SignUpInputState(
        option: option ?? this.option,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        birthdate: birthdate ?? this.birthdate,
        password: password ?? this.password,
        confirmed: confirmed ?? this.confirmed,
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
