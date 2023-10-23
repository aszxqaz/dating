part of 'signin_bloc.dart';

enum SignInMethod { otp, password }

enum SignInStage { empty, input, verify }

@immutable
class SignInState {
  const SignInState({
    required this.method,
    required this.stage,
    this.error = '',
    this.loading = false,
    this.fieldErrors = const {},
    this.authenticated = false,
    this.profile,
  });

  static const initial = SignInState(
    method: SignInMethod.otp,
    stage: SignInStage.input,
  );

  final String error;
  final Map<String, String> fieldErrors;
  final bool loading;
  final SignInMethod method;
  final SignInStage stage;
  final bool authenticated;
  final Profile? profile;

  copyWith({
    SignInMethod? method,
    SignInStage? stage,
    String? error,
    bool? loading,
    Map<String, String>? fieldErrors,
    bool? authenticated,
    Profile? profile,
  }) =>
      SignInState(
        method: method ?? this.method,
        stage: stage ?? this.stage,
        error: error ?? this.error,
        loading: loading ?? this.loading,
        fieldErrors: fieldErrors ?? this.fieldErrors,
        authenticated: authenticated ?? this.authenticated,
        profile: profile ?? this.profile,
      );

  toLoading() => copyWith(
        loading: true,
        error: '',
      );

  toError(String error) => copyWith(
        error: error,
        loading: false,
      );

  toPasswordMethod() => const SignInState(
        method: SignInMethod.password,
        stage: SignInStage.empty,
      );

  toOtpMethod() => const SignInState(
        method: SignInMethod.otp,
        stage: SignInStage.input,
      );

  toOtpVerifyStage() => const SignInState(
        method: SignInMethod.otp,
        stage: SignInStage.verify,
      );

  SignInState toFieldErrors(Map<String, String> errors) => copyWith(
        fieldErrors: {
          ...fieldErrors,
          ...errors,
        },
        loading: false,
      );
}
