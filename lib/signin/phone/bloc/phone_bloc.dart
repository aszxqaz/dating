import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'phone_state.dart';
part 'phone_event.dart';

class PhoneSignInBloc extends Bloc<PhoneSignInEvent, PhoneSignInState> {
  PhoneSignInBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const PhoneSignInInputState(phone: '+')) {
    on<PhoneSignInPhoneChanged>((event, emit) {
      emit(PhoneSignInInputState(phone: event.phone));
    });

    on<PhoneSignInPhoneSubmit>((event, emit) async {
      assert(state is PhoneSignInInputState);
      _phone = (state as PhoneSignInInputState).phone;
      emit(const PhoneSignInLoadingState());
      try {
        await _authRepository.signInWithPhone(phone: _phone!);
        emit(const PhoneSignInVerifyState(code: ''));
      } catch (e) {
        emit(PhoneSignInErrorState(error: e));
      }
    });

    on<PhoneSignInCodeChanged>((event, emit) {
      emit(PhoneSignInVerifyState(code: event.code));
    });

    on<PhoneSignInVerifySubmit>((event, emit) async {
      assert(state is PhoneSignInVerifyState);
      final code = (state as PhoneSignInVerifyState).code;
      emit(const PhoneSignInLoadingState());
      try {
        await _authRepository.verifyCode(phone: _phone!, code: code);
        // emit(PhoneSignInSuccessState(phone: _phone!));
      } catch (e) {
        emit(PhoneSignInErrorState(error: e));
      }
    });
  }

  final AuthRepository _authRepository;
  String? _phone;

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
