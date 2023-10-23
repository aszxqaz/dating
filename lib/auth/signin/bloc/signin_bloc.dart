import 'dart:async';

import 'package:dating/debug.dart';
import 'package:dating/misc/validators.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signin_state.dart';
part 'signin_event.dart';

class SignInBloc extends Bloc<_SignInEvent, SignInState> {
  SignInBloc() : super(SignInState.initial) {
    on<_OtpRequested>(_onOtpRequested);
    on<_PasswordSubmit>(_onPasswordSubmit);
    on<_OtpVerified>(_onOtpVerified);
    on<_MethodSwitched>(_onMethodSwitched);
  }

  String? _phone;

  static SignInBloc of(BuildContext context) => context.read<SignInBloc>();

  // ---
  // --- SUBMIT PHONE NUMBER AND REQUEST OTP CODE
  // ---
  FutureOr<void> _onOtpRequested(
    _OtpRequested event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.toLoading());

    final phoneError = await validatePhoneNumber(event.phone);

    if (phoneError != null) {
      emit(state.toFieldErrors({'phone': phoneError}));
      return;
    }

    // await Future.delayed(const Duration(milliseconds: 400));

    final ok = kDebugMode
        ? true
        : await supabaseService.requestOtp(phone: event.phone);

    // const ok = true;

    if (ok == true) {
      _phone = event.phone;
      emit(state.toOtpVerifyStage());
    } else {
      emit(state.copyWith(error: 'Unknown error occured'));
    }
  }

  // ---
  // --- SUBMIT PHONE NUMBER AND PASSWORD
  // ---
  FutureOr<void> _onPasswordSubmit(
    _PasswordSubmit event,
    Emitter<SignInState> emit,
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

    final ok = await supabaseService.signInWithPassword(
      phone: event.phone,
      password: event.password,
    );

    if (xVerifyOtpEnabled) {
      if (ok == true) {
        emit(state.toOtpVerifyStage());
      }
    }

    if (ok != true) {
      emit(state.toError('Unknown error occured'));
    }
  }

  // ---
  // --- VERIFY OTP CODE
  // ---
  FutureOr<void> _onOtpVerified(
    _OtpVerified event,
    Emitter<SignInState> emit,
  ) async {
    if (_phone == null) return;

    emit(state.toLoading());

    final ok = kDebugMode
        ? true
        : await supabaseService.verifyCode(
            phone: _phone!,
            code: event.code,
          );

    if (ok == true) {
      final profile = await supabaseService.fetchUserProfile();

      emit(state.copyWith(authenticated: true, profile: profile));
    } else {
      emit(state.toError('Invalid verification code'));
    }
  }

  FutureOr<void> _onMethodSwitched(
    _MethodSwitched event,
    Emitter<SignInState> emit,
  ) async {
    if (event.toPassword) {
      if (state.method == SignInMethod.otp) {
        emit(state.toPasswordMethod());
      }
    } else {
      if (state.method == SignInMethod.password) {
        emit(state.toOtpMethod());
      }
    }
  }

  // ---
  // --- PUBLIC API
  // ---
  void requestOtp(String phone) {
    add(_OtpRequested(phone: phone));
  }

  void verifyOtp(String code) {
    add(_OtpVerified(code: code));
  }

  void submit(String phone, String password) {
    add(_PasswordSubmit(phone: phone, password: password));
  }

  void toPasswordMethod() {
    add(const _MethodSwitched(toPassword: true));
  }

  void toOtpMethod() {
    add(const _MethodSwitched(toPassword: false));
  }
}
