part of 'phone_bloc.dart';

@immutable
sealed class PhoneSignInEvent {
  const PhoneSignInEvent();
}

final class PhoneSignInPhoneChanged extends PhoneSignInEvent {
  const PhoneSignInPhoneChanged({required this.phone});
  final String phone;
}

final class PhoneSignInCodeChanged extends PhoneSignInEvent {
  const PhoneSignInCodeChanged({required this.code});
  final String code;
}

final class PhoneSignInPhoneSubmit extends PhoneSignInEvent {
  const PhoneSignInPhoneSubmit();
}

final class PhoneSignInVerifySubmit extends PhoneSignInEvent {
  const PhoneSignInVerifySubmit();
}
