part of 'phone_bloc.dart';

@immutable
sealed class PhoneSignInState {
  const PhoneSignInState({
    this.error,
    this.loading = false,
  });

  final String? error;
  final bool loading;
}

final class PhoneSignInInputState extends PhoneSignInState {
  const PhoneSignInInputState({
    required this.phone,
    String? error,
    bool loading = false,
  }) : super(
          error: error,
          loading: loading,
        );

  PhoneSignInInputState copyWith({
    String? phone,
    String? error,
    bool? loading,
  }) =>
      PhoneSignInInputState(
        phone: phone ?? this.phone,
        error: error ?? this.error,
        loading: loading ?? this.loading,
      );

  final String phone;
}

final class PhoneSignInVerifyState extends PhoneSignInState {
  const PhoneSignInVerifyState({
    required this.code,
    String? error,
    bool loading = false,
  }) : super(
          error: error,
          loading: loading,
        );

  PhoneSignInVerifyState copyWith({
    String? code,
    String? error,
    bool? loading,
  }) =>
      PhoneSignInVerifyState(
        code: code ?? this.code,
        error: error ?? this.error,
        loading: loading ?? this.loading,
      );

  final String code;
}
