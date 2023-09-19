import 'package:bloc/bloc.dart';
import 'package:dating/formz/formz.dart';
import 'package:dating/signup/bloc/formz/birthdate.dart';
import 'package:dating/signup/bloc/formz/formz.dart';
import 'package:dating/supabase/auth_service.dart';
import 'package:flutter/foundation.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInputState.initial()) {
    // Input changed event
    on<SignUpInputChanged>(
      (event, emit) {
        assert(state is SignUpInputState);

        emit(
          (state as SignUpInputState).copyWith(
            option: event.option,
            phone: event.phone,
            email: event.email,
            password: event.password,
            confirmed: event.confirmed,
            birthdate: event.birthdate,
          ),
        );
      },
    );

    // --- SUBMIT ---
    on<SignUpSubmitEvent>((event, emit) async {
      final state = this.state as SignUpInputState;

      emit(state.copyWith(loading: true));

      try {
        final phone = state.option.isPhoneOrBoth ? state.phone.value : null;
        final email = state.option.isEmailOrBoth ? state.email.value : null;

        await authService.signUp(
          phone: phone,
          email: email,
          password: state.password.value,
          birthdate: state.birthdate.value,
        );

        if (state.option.isPhoneOrBoth) {
          emit(SignUpVerifyState.initial());
        }
      } on AuthenticationError catch (error) {
        emit(state.copyWith(loading: false, error: error.message));
      } catch (err) {
        debugPrint(err.toString());
        emit(state.copyWith(
          loading: false,
          error: kDebugMode ? err.toString() : 'Unknown error occured',
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
        await authService.verifyCode(phone: _phone!, code: state.code);
      } catch (e) {
        emit(state.copyWith(
          loading: false,
          error: kDebugMode ? e.toString() : 'Unknown error occured.',
        ));
      }
    });
  }

  String? _phone;

  // --- First stage
  void changeOption(SignUpOption? option) {
    debugPrint(option.toString());
    if (option != null) {
      add(SignUpInputChanged(option: option));
    }
  }

  void changePhone(String phone) {
    add(SignUpInputChanged(phone: Phone.dirty(phone)));
  }

  void changeEmail(String email) {
    add(SignUpInputChanged(email: Email.dirty(email)));
  }

  void changeBirthdate(DateTime? birthdate) {
    final str = birthdate == null
        ? ''
        : '${birthdate.year}-${birthdate.month}-${birthdate.day}';
    add(SignUpInputChanged(birthdate: Birthdate.pure(str)));
  }

  void changePassword(String password) {
    final signUpState = state as SignUpInputState;
    add(
      SignUpInputChanged(
        password: Password.dirty(password),
        confirmed: signUpState.confirmed.copyWith(other: password),
      ),
    );
  }

  void changeConfirmed(String confirmed) {
    final signUpState = state as SignUpInputState;
    add(
      SignUpInputChanged(
        confirmed: signUpState.confirmed.copyWith(value: confirmed),
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
