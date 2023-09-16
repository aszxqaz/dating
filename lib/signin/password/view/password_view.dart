import 'package:authentication_repository/authentication_repository.dart';
import 'package:dating/app/app.dart';
import 'package:dating/extensions.dart';
import 'package:dating/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordSignIn extends StatelessWidget {
  const PasswordSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordSignInBloc>(
      create: (context) => PasswordSignInBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: const _PasswordSignIn(),
    );
  }
}

class _PasswordSignIn extends HookWidget {
  const _PasswordSignIn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordSignInBloc, PasswordSignInState>(
      builder: (context, state) {
        switch (state) {
          case PasswordSignInLoadingState _:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case PasswordSignInErrorState _:
            return Center(
              child: Text('ERROR: ${state.error.toString()}'),
            );
          case PasswordSignInSuccessState _:
            BlocProvider.of<AppBloc>(context).authenticate();
            return const SizedBox();
          case PasswordSignInInputState _:
            return _PasswordSignInInput();
        }
      },
    );
  }
}

class _PasswordSignInInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PasswordInput(getter: valueGetter),
          Text(
            'Sign in with password',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 240,
            child: TextField(
              controller: phoneController,
              onChanged: (value) {
                context
                    .read<PasswordSignInBloc>()
                    .changeInput(phone: phoneController.text);
              },
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Phone number',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: TextField(
              controller: passwordController,
              onChanged: (value) {
                context
                    .read<PasswordSignInBloc>()
                    .changeInput(password: passwordController.text);
              },
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: context.read<PasswordSignInBloc>().submitInput,
            child: const Text('Sign In'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: context.read<SignInBloc>().goToPhone,
            child: const Text('Sign in with SMS-code'),
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
