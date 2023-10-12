import 'package:dating/supabase/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'phone_state.dart';
part 'phone_event.dart';

class PhoneSignInBloc extends Bloc<PhoneSignInEvent, PhoneSignInState> {
  PhoneSignInBloc() : super(const PhoneSignInInputState(phone: '+')) {
    on<PhoneSignInPhoneChanged>((event, emit) {
      emit(PhoneSignInInputState(phone: event.phone));
    });

    on<PhoneSignInPhoneSubmit>((event, emit) async {
      final state = this.state as PhoneSignInInputState;
      _phone = state.phone;

      emit(state.copyWith(loading: true));

      try {
        await authService.signInWithPhone(phone: _phone!);
        emit(const PhoneSignInVerifyState(code: ''));
      } catch (e) {
        emit(state.copyWith(error: 'Unknown error occured'));
      }
    });

    on<PhoneSignInCodeChanged>((event, emit) {
      emit(PhoneSignInVerifyState(code: event.code));
    });

    on<PhoneSignInVerifySubmit>((event, emit) async {
      final state = this.state as PhoneSignInVerifyState;

      emit(state.copyWith(loading: true));

      try {
        await authService.verifyCode(phone: _phone!, code: state.code);
      } catch (e) {
        emit(state.copyWith(error: 'Unknown error occured'));
      }
    });
  }

  String? _phone;

  static PhoneSignInBloc of(BuildContext context) =>
      context.read<PhoneSignInBloc>();

  void changePhone(String phone) {
    add(PhoneSignInPhoneChanged(phone: phone));
  }

  void submitInput() {
    add(const PhoneSignInPhoneSubmit());
  }

  void changeCode(String code) {
    add(PhoneSignInCodeChanged(code: code));
  }

  void submitVerify() {
    add(const PhoneSignInVerifySubmit());
  }
}
