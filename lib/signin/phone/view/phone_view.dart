// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dating/app/bloc/app_bloc.dart';
import 'package:dating/extensions.dart';
import 'package:dating/signin/signin.dart';

class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneSignInBloc>(
      create: (context) => PhoneSignInBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: _PhoneSignIn(),
    );
  }
}

class _PhoneSignIn extends HookWidget {
  _PhoneSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneSignInBloc, PhoneSignInState>(
      builder: (context, state) {
        switch (state) {
          case PhoneSignInLoadingState _:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case PhoneSignInErrorState _:
            return Center(
              child: Text('ERROR: ${state.error.toString()}'),
            );
          case PhoneSignInVerifyState _:
            return _PhoneSignInVerifyView();
          case PhoneSignInSuccessState _:
            BlocProvider.of<AppBloc>(context).authenticate();
            return SizedBox();
          case PhoneSignInInputState _:
            return _PhoneSignInPhoneInput();
        }
      },
    );
  }
}

class _PhoneSignInPhoneInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PhoneInput(getter: valueGetter),
          Text(
            'Sign in with SMS-code',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 240,
            child: TextField(
              controller: controller,
              onChanged: (value) {
                context.read<PhoneSignInBloc>().changePhone(value);
              },
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your phone number...',
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<PhoneSignInBloc>().submitInput();
            },
            child: const Text('Send code'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: context.read<SignInBloc>().goToPassword,
            child: const Text('Sign in with password'),
          ),
          const SizedBox(height: 96),
          const Text('Don\'t have an account?'),
          TextButton(
            onPressed: context.read<AppBloc>().goToSignUp,
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

class _PhoneSignInVerifyView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Code verification',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          Text(
            'We\'ve sent you a message with the code. \nCheck your incoming messages and enter the code.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 180,
            child: TextField(
              controller: controller,
              onChanged: (value) {
                context.read<PhoneSignInBloc>().changeCode(value);
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your code...',
              ),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              context.read<PhoneSignInBloc>().submitVerify();
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
