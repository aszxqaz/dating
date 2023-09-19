import 'package:dating/signin/bloc/signin_bloc.dart';
import 'package:dating/signin/password/password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating/signin/phone/phone.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(),
      child: const _SignInPage(),
    );
  }
}

class _SignInPage extends StatelessWidget {
  const _SignInPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          switch (state.tab) {
            case SignInTabs.phone:
              return const PhoneSignIn();
            case SignInTabs.password:
              return const PasswordSignIn();
          }
        },
      ),
    );
  }
}
