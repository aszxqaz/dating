import 'package:authentication_repository/authentication_repository.dart';
import 'package:dating/app/app.dart';
import 'package:dating/extensions.dart';
import 'package:dating/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: const _SignUpPage(),
    );
  }
}

class _SignUpPage extends StatelessWidget {
  const _SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(
        supabaseClient: RepositoryProvider.of<SupabaseClient>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            switch (state) {
              case SignUpInputState _:
                return _SignUpInput();

              case SignUpVerifyState _:
                return _SignUpVerify();
            }
          },
        ),
      ),
    );
  }
}

class _SignUpInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final phoneController =
        useTextEditingController(text: '+995595506963'.ifDebug);
    final passwordController =
        useTextEditingController(text: '19920220'.ifDebug);
    final confirmedController =
        useTextEditingController(text: '19920220'.ifDebug);

    useEffect(() {
      context.read<SignUpBloc>().changePhone(phoneController.text);
      context.read<SignUpBloc>().changePassword(passwordController.text);
      context.read<SignUpBloc>().changeConfirmed(confirmedController.text);
    }, [phoneController, passwordController, confirmedController]);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign Up',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 240,
            child: TextField(
              controller: phoneController,
              onChanged: context.read<SignUpBloc>().changePhone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Phone number',
                labelText: 'Phone number',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: TextField(
              controller: passwordController,
              onChanged: context.read<SignUpBloc>().changePassword,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: TextField(
              controller: confirmedController,
              onChanged: context.read<SignUpBloc>().changeConfirmed,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm password',
                labelText: 'Confirm password',
              ),
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
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Already have an account?'),
          TextButton(
            onPressed: context.read<AppBloc>().goToSignIn,
            child: const Text('Sign In'),
          ),
        ],
      ),
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
