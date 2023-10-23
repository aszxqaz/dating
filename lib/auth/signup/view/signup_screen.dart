import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:animations/animations.dart';
import 'package:dating/auth/bloc/auth_bloc.dart';
import 'package:dating/auth/signup/bloc/signup_bloc.dart';
import 'package:dating/common/animations.dart';
import 'package:dating/common/otp_field/otp_field.dart';
import 'package:dating/common/password_field.dart';
import 'package:dating/common/phone_field/phone_field.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/misc/submit_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '_signup_input.dart';
part '_signup_verify.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (previous, current) =>
            previous.authenticated != current.authenticated,
        listener: (context, state) {
          if (state.authenticated) {
            AuthBloc.of(context).authenticate(state.profile);
          }
        },
        child: BlocSelector<SignUpBloc, SignUpState, SignUpStage>(
          selector: (state) => state.stage,
          builder: (_, stage) {
            return SharedAxisSwitcherBuilder(
              type: SharedAxisTransitionType.horizontal,
              builder: (_) {
                switch (stage) {
                  case SignUpStage.input:
                    return const _SignUpInput();
                  case SignUpStage.verify:
                    return const _SignUpVerify();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
