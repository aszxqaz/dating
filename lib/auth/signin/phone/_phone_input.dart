part of '../signin_screen.dart';

class _PhoneSignInInput extends StatefulWidget {
  const _PhoneSignInInput();

  @override
  State<_PhoneSignInInput> createState() => _PhoneSignInInputState();
}

class _PhoneSignInInputState extends State<_PhoneSignInInput> {
  late final PhoneFieldController phoneController;
  final phoneNumberUtil = PhoneNumberUtil();

  @override
  void didChangeDependencies() {
    phoneController = PhoneFieldController(
        countryCode: AuthBloc.of(context).state.countryCode);

    super.didChangeDependencies();
  }

  void submit() {
    if (context.mounted) {
      SignInBloc.of(context).requestOtp(phoneController.number);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 96),
        Text(
          'Sign in with SMS-code',
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
                controller: phoneController,
                errorText: phoneError,
              );
            },
          ),
        ),
        const SizedBox(height: 48),
        BlocSelector<SignInBloc, SignInState, bool>(
          selector: (state) => state.loading,
          builder: (context, loading) {
            return SubmitButton(
              submitting: loading,
              onPressed: submit,
              label: 'Send code',
            );
          },
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: SignInBloc.of(context).toPasswordMethod,
          child: const Text('Sign in with password'),
        ),
        const Spacer(),
        TextButton(
          onPressed: AuthBloc.of(context).signInWithGoogle,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Login with Google'),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset('assets/social/google.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: AuthBloc.of(context).signInWithFacebook,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Login with Facebook'),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset('assets/social/facebook.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 24,
          child: BlocSelector<SignInBloc, SignInState, String?>(
            selector: (SignInState state) => state.error,
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
          onPressed: AuthBloc.of(context).goToSignUp,
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
