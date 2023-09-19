import 'package:dating/app/app.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/signin/signin.dart';
import 'package:dating/signup/bloc/formz/formz.dart';
import 'package:dating/formz/formz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordSignIn extends StatelessWidget {
  const PasswordSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordSignInBloc(),
      child: const _PasswordSignIn(),
    );
  }
}

class _PasswordSignIn extends HookWidget {
  const _PasswordSignIn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordSignInBloc, PasswordSignInState>(
      builder: (_, state) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _PasswordSignInInput();
      },
    );
  }
}

class _PasswordSignInInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final phoneController =
        useTextEditingController(text: '+995595506963'.ifDebug);

    final passwordController =
        useTextEditingController(text: '19920220'.ifDebug);

    useEffect(() {
      context.read<PasswordSignInBloc>().changePhone(phoneController.text);
      context
          .read<PasswordSignInBloc>()
          .changePassword(passwordController.text);

      return null;
    }, [phoneController, passwordController]);

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
            child: _PhoneTextField(phoneController: phoneController),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: _PasswordTextField(passwordController: passwordController),
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
          const SizedBox(height: 24),
          SizedBox(
            height: 24,
            child:
                BlocSelector<PasswordSignInBloc, PasswordSignInState, String?>(
              selector: (PasswordSignInState state) => state.error,
              builder: (context, error) => Text(
                error ?? '',
                style: context.textTheme.bodyMedium!
                    .copyWith(color: context.colorScheme.error),
              ),
            ),
          ),
          const SizedBox(height: 36),
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

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordSignInBloc, PasswordSignInState>(
      buildWhen: (prev, cur) =>
          (prev as PasswordSignInInputState).password !=
          (cur as PasswordSignInInputState).password,
      builder: (context, state) {
        return TextField(
          controller: passwordController,
          onChanged: context.read<PasswordSignInBloc>().changePassword,
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            labelText: 'Password',
            errorText: (state as PasswordSignInInputState)
                .password
                .displayError
                ?.description,
          ),
        );
      },
    );
  }
}

class _PhoneTextField extends StatelessWidget {
  const _PhoneTextField({
    required this.phoneController,
  });

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordSignInBloc, PasswordSignInState>(
      buildWhen: (prev, cur) =>
          (prev as PasswordSignInInputState).phone !=
          (cur as PasswordSignInInputState).phone,
      builder: (context, state) {
        return TextField(
          controller: phoneController,
          onChanged: context.read<PasswordSignInBloc>().changePhone,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Phone number',
            labelText: 'Phone number',
            errorText: (state as PasswordSignInInputState)
                .phone
                .displayError
                ?.description,
          ),
        );
      },
    );
  }
}
