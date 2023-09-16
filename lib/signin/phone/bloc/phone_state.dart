part of 'phone_bloc.dart';

@immutable
sealed class PhoneSignInState {
  const PhoneSignInState();
}

final class PhoneSignInInputState extends PhoneSignInState {
  const PhoneSignInInputState({required this.phone});
  final String phone;
}

final class PhoneSignInVerifyState extends PhoneSignInState {
  const PhoneSignInVerifyState({required this.code});
  final String code;
}

final class PhoneSignInLoadingState extends PhoneSignInState {
  const PhoneSignInLoadingState();
}

final class PhoneSignInErrorState extends PhoneSignInState {
  const PhoneSignInErrorState({required this.error});
  final Object error;
}

final class PhoneSignInSuccessState extends PhoneSignInState {
  const PhoneSignInSuccessState({required this.phone});
  final String phone;
}
