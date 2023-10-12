import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dating/app/bloc/app_bloc.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/signin/signin.dart';

class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhoneSignInBloc(),
      child: const _PhoneSignIn(),
    );
  }
}

class _PhoneSignIn extends HookWidget {
  const _PhoneSignIn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneSignInBloc, PhoneSignInState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        switch (state) {
          case PhoneSignInVerifyState _:
            return _PhoneSignInVerifyView();

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
    final controller = useTextEditingController(text: '+995595506963'.ifDebug);

    useEffect(() {
      // context.read<PhoneSignInBloc>().changePhone(controller.text);
      PhoneSignInBloc.of(context).changePhone(controller.text);

      return null;
    }, [controller]);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // PhoneInput(getter: valueGetter),
        const SizedBox(height: 48),
        const Spacer(),
        Text(
          'Sign in with SMS-code',
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: 240,
          child: TextField(
            controller: controller,
            onChanged: (value) {
              context.read<PhoneSignInBloc>().changePhone(value);
            },
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
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
        const SizedBox(height: 24),
        SizedBox(
          height: 24,
          child: BlocSelector<PhoneSignInBloc, PhoneSignInState, String?>(
            selector: (PhoneSignInState state) => state.error,
            builder: (context, error) => Text(
              error ?? '',
              style: context.textTheme.bodyMedium!
                  .copyWith(color: context.colorScheme.error),
            ),
          ),
        ),
        const Spacer(),
        const Text('Don\'t have an account?'),
        TextButton(
          onPressed: context.read<AppBloc>().goToSignUp,
          child: const Text('Sign Up'),
        )
      ],
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
                context.read<PhoneSignInBloc>().changeCode(value);
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
              context.read<PhoneSignInBloc>().submitVerify();
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
