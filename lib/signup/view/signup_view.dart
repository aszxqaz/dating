import 'package:dating/app/app.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/signin/phone/view/_auth_screen_wrapper.dart';
import 'package:dating/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'date_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: const _SignUpPage(),
    );
  }
}

class _SignUpPage extends StatelessWidget {
  const _SignUpPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final screen = switch (state) {
            SignUpInputState _ => _SignUpInput(),
            SignUpVerifyState _ => _SignUpVerify()
          };

          return AuthScreenWrapper(child: screen);
        },
      ),
    );
  }
}

class _SignUpInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final phoneController =
        useTextEditingController(text: '+995595506963'.ifDebug);
    final emailController =
        useTextEditingController(text: 'maxim11@maxim.com'.ifDebug);
    final passwordController =
        useTextEditingController(text: '19920220'.ifDebug);
    final confirmedController =
        useTextEditingController(text: '19920220'.ifDebug);

    useEffect(() {
      context.read<SignUpBloc>().changePhone(phoneController.text);
      context.read<SignUpBloc>().changeEmail(emailController.text);
      context.read<SignUpBloc>().changePassword(passwordController.text);
      context.read<SignUpBloc>().changeConfirmed(confirmedController.text);

      return null;
    }, [
      phoneController,
      emailController,
      passwordController,
      confirmedController
    ]);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 48),
        const Spacer(),
        Text(
          'Sign Up',
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 32),
        BlocBuilder<SignUpBloc, SignUpState>(
            buildWhen: (p, c) =>
                (p as SignUpInputState).option !=
                (c as SignUpInputState).option,
            builder: (context, state) {
              return Column(
                children: [
                  _OptionRadioGroup(
                    option: (state as SignUpInputState).option,
                  ),
                  SizedBox(
                    width: 240,
                    child: Column(
                      children: [
                        if (state.option.isPhoneOrBoth)
                          TextField(
                            controller: phoneController,
                            onChanged: context.read<SignUpBloc>().changePhone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: 'Phone number',
                              labelText: 'Phone number',
                            ),
                          ),
                        if (state.option.isBoth) const SizedBox(height: 16),
                        if (state.option.isEmailOrBoth)
                          TextField(
                            controller: emailController,
                            onChanged: context.read<SignUpBloc>().changeEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                            ),
                          )
                      ],
                    ),
                  )
                ],
              );
            }),
        const SizedBox(height: 16),
        SizedBox(
          width: 240,
          child: Column(
            children: [
              DateField(
                onChanged: context.read<SignUpBloc>().changeBirthdate,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                onChanged: context.read<SignUpBloc>().changePassword,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmedController,
                onChanged: context.read<SignUpBloc>().changeConfirmed,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm password',
                  labelText: 'Confirm password',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: context.read<SignUpBloc>().submit,
          child: const Text('Sign Up'),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 24,
          child: BlocSelector<SignUpBloc, SignUpState, String?>(
            selector: (SignUpState state) =>
                state is SignUpInputState ? state.error : null,
            builder: (context, error) => Text(
              error ?? '',
              style: context.textTheme.bodyMedium!
                  .copyWith(color: context.colorScheme.error),
              softWrap: true,
            ),
          ),
        ),
        const Spacer(),
        const Text('Already have an account?'),
        TextButton(
          onPressed: context.read<AppBloc>().goToSignIn,
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}

class _OptionRadioGroup extends StatelessWidget {
  const _OptionRadioGroup({
    required this.option,
  });

  final SignUpOption option;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<SignUpOption>(
          value: SignUpOption.phone,
          groupValue: option,
          onChanged: context.read<SignUpBloc>().changeOption,
        ),
        const Text('Phone'),
        const SizedBox(width: 24),
        Radio<SignUpOption>(
          value: SignUpOption.email,
          groupValue: option,
          onChanged: context.read<SignUpBloc>().changeOption,
        ),
        const Text('Email'),
        const SizedBox(width: 24),
        Radio<SignUpOption>(
          value: SignUpOption.both,
          groupValue: option,
          onChanged: context.read<SignUpBloc>().changeOption,
        ),
        const Text('Both'),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _SignUpVerify extends HookWidget {
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
          const Text(
            'We\'ve sent you a message with the code. \nCheck your incoming messages and enter the code.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 180,
            child: TextField(
              controller: controller,
              onChanged: (value) {
                context.read<SignUpBloc>().changeCode(value);
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter your code...',
              ),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              context.read<SignUpBloc>().verify();
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
