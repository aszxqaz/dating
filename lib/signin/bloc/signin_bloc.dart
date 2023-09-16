import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'signin_state.dart';
part 'signin_event.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInState.initial()) {
    on<SignInTabChanged>((event, emit) {
      emit(SignInState(tab: event.tab));
    });
  }

  void goToPhone() {
    add(const SignInTabChanged(tab: SignInTabs.phone));
  }

  void goToPassword() {
    add(const SignInTabChanged(tab: SignInTabs.password));
  }
}
