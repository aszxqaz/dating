part of '../signin_screen.dart';

class _PhoneSignInVerify extends StatefulWidget {
  const _PhoneSignInVerify();

  @override
  State<_PhoneSignInVerify> createState() => _PhoneSignInVerifyState();
}

class _PhoneSignInVerifyState extends State<_PhoneSignInVerify> {
  final controller = OtpFieldController(6);

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
  void dispose() {
    controller.dispose();
    super.dispose();
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
          BlocSelector<SignInBloc, SignInState, bool>(
            selector: (state) => state.loading,
            builder: (_, loading) {
              return SubmitButton(
                onPressed: () {
                  SignInBloc.of(context).verifyOtp(controller.text);
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

// extension ToString on SmsMessage {
//   String get describe =>
//       'address: $address, subject: $subject, service: $serviceCenterAddress, threadId: $threadId, body: $body';
// }
