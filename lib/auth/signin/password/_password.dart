part of '../signin_screen.dart';

class _PasswordSignIn extends StatefulWidget {
  const _PasswordSignIn();

  @override
  State<_PasswordSignIn> createState() => _PasswordSignInState();
}

class _PasswordSignInState extends State<_PasswordSignIn> {
  final phone = PhoneFieldController();
  final password = TextEditingController(text: '19920220'.ifDebug);

  submit() {
    SignInBloc.of(context).submit(phone.number, password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 96),
          Text(
            'Sign in with password',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 64),
          SizedBox(
            width: 280,
            child: BlocSelector<SignInBloc, SignInState, String?>(
              selector: (state) => state.fieldErrors['phone'],
              builder: (_, phoneError) {
                return PhoneField(
                  controller: phone,
                  errorText: phoneError,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 280,
            child: BlocSelector<SignInBloc, SignInState, String?>(
              selector: (state) => state.fieldErrors['password'],
              builder: (_, passwordError) {
                return ObscureTextField(
                  controller: password,
                  errorText: passwordError,
                  labelText: 'Password',
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          BlocSelector<SignInBloc, SignInState, bool>(
            selector: (state) => state.loading,
            builder: (_, loading) {
              return SubmitButton(
                onPressed: submit,
                label: 'Sign In',
                submitting: loading,
              );
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: SignInBloc.of(context).toOtpMethod,
            child: const Text('Sign in with SMS-code'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 24,
            child: BlocSelector<SignInBloc, SignInState, String>(
              selector: (state) => state.error,
              builder: (context, error) => Text(
                error,
                style: context.textTheme.bodyMedium!
                    .copyWith(color: context.colorScheme.error),
              ),
            ),
          ),
          const Spacer(),
          const Text('Don\'t have an account?'),
          TextButton(
            onPressed: AuthBloc.of(context).goToSignUp,
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
