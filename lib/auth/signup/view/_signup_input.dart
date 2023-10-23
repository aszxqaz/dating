part of 'signup_screen.dart';

class _SignUpInput extends StatefulWidget {
  const _SignUpInput();

  @override
  State<_SignUpInput> createState() => _SignUpInputState();
}

class _SignUpInputState extends State<_SignUpInput> {
  late final PhoneFieldController phone;
  final password = TextEditingController(text: '19920220'.ifDebug);
  final confirmed = TextEditingController(text: '19920220'.ifDebug);

  @override
  void didChangeDependencies() {
    phone = PhoneFieldController(
        countryCode: AuthBloc.of(context).state.countryCode);
    super.didChangeDependencies();
  }

  void submit() {
    SignUpBloc.of(context).submit(phone.number, password.text, confirmed.text);
  }

  @override
  Widget build(BuildContext context) {
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
        SizedBox(
          width: 280,
          child: BlocSelector<SignUpBloc, SignUpState, String?>(
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
          child: Column(
            children: [
              BlocSelector<SignUpBloc, SignUpState, String?>(
                selector: (state) => state.fieldErrors['password'],
                builder: (_, passwordError) {
                  return ObscureTextField(
                    controller: password,
                    labelText: 'Password',
                    errorText: passwordError,
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocSelector<SignUpBloc, SignUpState, String?>(
                selector: (state) => state.fieldErrors['confirmed'],
                builder: (_, confirmError) {
                  return ObscureTextField(
                    controller: confirmed,
                    labelText: 'Confirm password',
                    errorText: confirmError,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        BlocSelector<SignUpBloc, SignUpState, bool>(
          selector: (state) => state.loading,
          builder: (_, loading) {
            return SubmitButton(
              submitting: loading,
              onPressed: submit,
              label: 'Sign Up',
            );
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 24,
          child: Text(
            '',
            style: context.textTheme.bodyMedium!
                .copyWith(color: context.colorScheme.error),
            softWrap: true,
          ),
        ),
        const Spacer(),
        const Text('Already have an account?'),
        TextButton(
          onPressed: AuthBloc.of(context).goToSignIn,
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
