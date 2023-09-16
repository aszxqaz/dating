import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordSignInBloc
    extends Bloc<PasswordSignInEvent, PasswordSignInState> {
  PasswordSignInBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(
          PasswordSignInInputState.initial(),
        ) {
    // --- Input changed event
    on<PasswordSignInInputChanged>((event, emit) {
      assert(state is PasswordSignInInputState);

      emit((state as PasswordSignInInputState).copyWith(
        phone: event.phone,
        password: event.password,
      ));
    });

    // --- Submit event
    on<PasswordSignInSubmit>((event, emit) async {
      assert(state is PasswordSignInInputState);

      final phone = (state as PasswordSignInInputState).phone;
      final password = (state as PasswordSignInInputState).password;

      emit(const PasswordSignInLoadingState());

      try {
        await _authRepository.signInWithPassword(
          phoneOrEmail: phone,
          password: password,
        );
        emit(const PasswordSignInSuccessState());
      } catch (e) {
        emit(PasswordSignInErrorState(error: e));
      }
    });
  }

  final AuthRepository _authRepository;

  void changeInput({
    String? phone,
    String? password,
  }) {
    add(PasswordSignInInputChanged(
      phone: phone,
      password: password,
    ));
  }

  void submitInput() {
    add(const PasswordSignInSubmit());
  }
}
