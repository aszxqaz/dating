part of 'signup_screen.dart';

class _SignUpVerify extends StatefulWidget {
  const _SignUpVerify();

  @override
  State<_SignUpVerify> createState() => _SignUpVerifyState();
}

class _SignUpVerifyState extends State<_SignUpVerify> {
  final controller = OtpFieldController(6);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidSmsRetriever.listenForOneTimeConsent(senderPhoneNumber: 'VGSMS')
          .then((message) async {
        if (message != null) {
          final code = RegExp(r'\d{6}').firstMatch(message);
          if (code != null) {
            controller.setText(code[0]!);
          }
        }
        await AndroidSmsRetriever.stopOneTimeConsentListener();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            width: 300,
            child: OtpField(
              controller: controller,
            ),
          ),
          const SizedBox(height: 48),
          BlocSelector<SignUpBloc, SignUpState, bool>(
            selector: (state) => state.loading,
            builder: (_, loading) {
              return SubmitButton(
                onPressed: () {
                  SignUpBloc.of(context).verifyOtp(controller.text);
                },
                label: 'Sign In',
                submitting: loading,
              );
            },
          ),
        ],
      ),
    );
  }
}
