import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dating/formz/formz.dart';
import 'package:dating/signup/bloc/formz/formz.dart';
import 'package:flutter/material.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpInputState.initial()) {
    // Input changed event
    on<SignUpInputChanged>(
      (event, emit) {
        assert(state is SignUpInputState);

        emit(
          (state as SignUpInputState).copyWith(
            phone: event.phone,
            password: event.password,
            confirmed: event.confirmed,
          ),
        );
      },
    );

    on<SignUpSubmitEvent>((event, emit) async {
      final state = this.state as SignUpInputState;

      emit(state.copyWith(loading: true));

      try {
        await _authRepository.signUp(
          phone: state.phone,
          password: state.password,
        );
        emit(SignUpVerifyState.initial());
      } on AuthenticationRepositorySignUpError catch (error) {
        emit(state.copyWith(
          loading: false,
          error: error.message,
        ));
      }
    });

    on<SignUpCodeChanged>((event, emit) {
      emit(SignUpVerifyState(code: event.code));
    });

    on<SignUpVerifyEvent>((event, emit) async {
      final state = this.state as SignUpVerifyState;

      emit(state.copyWith(loading: true));

      try {
        await _authRepository.verifyCode(phone: _phone!, code: state.code);
      } catch (e) {
        emit(state.copyWith(loading: false, error: 'Unknown error occured.'));
      }
    });
  }

  final AuthRepository _authRepository;
  String? _phone;

  // --- First stage
  void changePhone(String phone) {
    add(
      SignUpInputChanged(
        phone: Phone.dirty(phone),
      ),
    );
  }

  void changePassword(String password) {
    final signUpState = state as SignUpInputState;
    add(
      SignUpInputChanged(
        password: Password.dirty(password),
        confirmed: signUpState._confirmed.copyWith(other: password),
      ),
    );
  }

  void changeConfirmed(String confirmed) {
    final signUpState = state as SignUpInputState;
    add(
      SignUpInputChanged(
        confirmed: signUpState._confirmed.copyWith(value: confirmed),
      ),
    );
  }

  void submit() {
    add(const SignUpSubmitEvent());
  }

  // --- Second stage
  void changeCode(String code) {
    add(SignUpCodeChanged(code: code));
  }

  void verify() {
    add(const SignUpVerifyEvent());
  }
}
