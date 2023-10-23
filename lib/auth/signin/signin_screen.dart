import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:animations/animations.dart';
import 'package:dating/auth/bloc/auth_bloc.dart';
import 'package:dating/auth/signin/bloc/signin_bloc.dart';
import 'package:dating/common/animations.dart';
import 'package:dating/common/otp_field/otp_field.dart';
import 'package:dating/common/password_field.dart';
import 'package:dating/common/phone_field/phone_field.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/misc/submit_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phone_number/phone_number.dart';

part 'password/_password.dart';
part 'phone/_phone.dart';
part 'phone/_phone_input.dart';
part 'phone/_phone_verify.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(),
      child: BlocListener<SignInBloc, SignInState>(
        listenWhen: (previous, current) =>
            previous.authenticated != current.authenticated,
        listener: (context, state) {
          if (state.authenticated) {
            AuthBloc.of(context).authenticate(state.profile);
          }
        },
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (_, state) {
            return FadeThroughSwitcherBuilder(
              builder: (_) {
                switch (state.method) {
                  case SignInMethod.otp:
                    return const _PhoneSignIn();
                  case SignInMethod.password:
                    return const _PasswordSignIn();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
