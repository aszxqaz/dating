import 'dart:async';

import 'package:dating/debug.dart';
import 'package:dating/misc/validators.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<_SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState.initial) {
    on<_InputSubmit>(_onInputSubmit);
    on<_VerificationSubmit>(_onVerificationSubmit);
  }

  String? _phone;

  static SignUpBloc of(BuildContext context) => context.read<SignUpBloc>();

  ///
  /// --- VERIFY OTP CODE
  ///
  FutureOr<void> _onVerificationSubmit(
    _VerificationSubmit event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final ok = xVerifyOtpEnabled
        ? await supabaseService.verifyCode(phone: _phone!, code: event.code)
        : true;

    if (ok == true) {
      final profile = await supabaseService.fetchUserProfile();

      emit(state.copyWith(authenticated: true, profile: profile));
    } else {
      emit(state.toError('Wrong code provided.'));
    }
  }

  // ---
  // --- SUBMIT PHONE NUMBER AND PASSWORD
  // ---
  FutureOr<void> _onInputSubmit(
    _InputSubmit event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.toLoading());

    final phoneError = await validatePhoneNumber(event.phone);

    if (phoneError != null) {
      emit(state.toFieldErrors({'phone': phoneError}));
      return;
    }

    final passwordError = validatePassword(event.password);

    if (passwordError != null) {
      emit(state.toFieldErrors({'password': passwordError}));
      return;
    }

    final confirmedMatch = event.password != event.confirmed;

    if (confirmedMatch) {
      emit(state.toFieldErrors({'confirmed': 'Password does not match'}));
      return;
    }

    final response = await supabaseService.signUp(
      phone: event.phone,
      password: event.password,
    );

    if (response?.ok == true) {
      _phone = event.phone;
      emit(state.toVerifyStage());
    } else if (response?.error != null) {
      emit(state.toError(response!.error!));
    }
  }

  // ---
  // --- PUBLIC API
  // ---
  void submit(String phone, String password, String confirmed) {
    add(_InputSubmit(
      phone: phone,
      password: password,
      confirmed: confirmed,
    ));
  }

  void verifyOtp(String code) {
    add(_VerificationSubmit(code: code));
  }
}
