part of 'signin_bloc.dart';

enum SignInTabs { phone, password }

@immutable
final class SignInState {
  const SignInState({required this.tab});

  factory SignInState.initial() => const SignInState(tab: SignInTabs.phone);

  final SignInTabs tab;
}
