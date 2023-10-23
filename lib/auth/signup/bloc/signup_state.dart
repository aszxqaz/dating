part of 'signup_bloc.dart';

typedef Dict = Map<String, String>;

enum SignUpStage { input, verify }

@immutable
class SignUpState {
  const SignUpState({
    required this.stage,
    this.error = '',
    this.loading = false,
    this.fieldErrors = const {},
    this.authenticated = false,
    this.profile,
  });

  static const initial = SignUpState(stage: SignUpStage.input);

  final SignUpStage stage;
  final Dict fieldErrors;
  final String error;
  final bool loading;
  final bool authenticated;
  final Profile? profile;

  SignUpState copyWith({
    SignUpStage? stage,
    String? error,
    bool? loading,
    Dict? fieldErrors,
    Profile? profile,
    bool? authenticated,
  }) =>
      SignUpState(
        stage: stage ?? this.stage,
        error: error ?? this.error,
        loading: loading ?? this.loading,
        fieldErrors: fieldErrors ?? this.fieldErrors,
        authenticated: authenticated ?? this.authenticated,
        profile: profile ?? this.profile,
      );

  toError(String error) => copyWith(error: error, loading: false);

  toFieldErrors(Dict errors) => copyWith(fieldErrors: {
        ...fieldErrors,
        ...errors,
      });

  toLoading() => copyWith(error: '', fieldErrors: {}, loading: true);

  toVerifyStage() => copyWith(
        error: '',
        fieldErrors: {},
        loading: false,
        stage: SignUpStage.verify,
      );
}
