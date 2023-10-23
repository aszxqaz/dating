import 'package:dating/auth/bloc/auth_bloc.dart';
import 'package:dating/auth/signin/_auth_screen_wrapper.dart';
import 'package:dating/auth/signin/signin_screen.dart';
import 'package:dating/auth/signup/view/signup_screen.dart';
import 'package:dating/common/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key, required this.countryCode});

  final String? countryCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(countryCode: countryCode),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.authenticated != current.authenticated,
        listener: (context, state) {
          if (state.authenticated) {
            // AppBloc.of(context).authenticate(state.profile);
          }
        },
        child: AuthScreenWrapper(
          child: BlocSelector<AuthBloc, AuthState, AuthScreen>(
            selector: (state) => state.screen,
            builder: (_, screen) {
              return FadeThroughSwitcherBuilder(
                builder: (_) {
                  switch (screen) {
                    case AuthScreen.signin:
                      return const SignInScreen();
                    case AuthScreen.signup:
                      return const SignUpScreen();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
