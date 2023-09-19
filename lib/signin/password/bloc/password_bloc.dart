import 'package:bloc/bloc.dart';
import 'package:dating/formz/formz.dart';
import 'package:dating/signup/bloc/formz/formz.dart';
import 'package:dating/supabase/auth_service.dart';
import 'package:flutter/material.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordSignInBloc
    extends Bloc<PasswordSignInEvent, PasswordSignInState> {
  PasswordSignInBloc()
      : super(
          PasswordSignInInputState.initial,
        ) {
    // --- Input changed event
    on<PasswordSignInInputChanged>((event, emit) {
      final state = this.state as PasswordSignInInputState;

      emit(state.copyWith(
        phone: event.phone != null
            ? state.phone.isPure
                ? Phone.pure(event.phone!)
                : Phone.dirty(event.phone!)
            : state.phone,
        password: event.password != null
            ? state.password.isPure
                ? Password.pure(event.password!)
                : Password.dirty(event.password!)
            : state.password,
      ));
    });

    // --- Submit event
    on<PasswordSignInSubmit>((event, emit) async {
      final state = this.state as PasswordSignInInputState;

      final phone = Phone.dirty(state.phone.value);
      final password = Password.dirty(state.password.value);

      if (phone.isNotValid || password.isNotValid) {
        emit(state.copyWith(phone: phone, password: password));
        return;
      }

      emit(state.copyWith(loading: true));

      final error = await authService.signInWithPassword(
        phoneOrEmail: state.phone.value,
        password: state.password.value,
      );

      if (error != null) {
        emit(state.copyWith(error: error.message, loading: false));
      }
    });
  }

  void changePhone(String phone) {
    add(PasswordSignInInputChanged(phone: phone));
  }

  void changePassword(String password) {
    add(PasswordSignInInputChanged(password: password));
  }

  void submitInput() {
    add(const PasswordSignInSubmit());
  }
}
