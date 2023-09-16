part of 'signin_bloc.dart';

@immutable
sealed class SignInEvent {
  const SignInEvent();
}

final class SignInTabChanged extends SignInEvent {
  const SignInTabChanged({required this.tab});

  final SignInTabs tab;
}
