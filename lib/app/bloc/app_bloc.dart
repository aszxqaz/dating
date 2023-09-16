import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AppUnauthenticatedState.initial()) {
    on<AppAuthenticatedEvent>((event, emit) {
      emit(const AppAuthenticatedState());
    });

    on<AppUnauthenticatedEvent>((event, emit) {
      emit(AppUnauthenticatedState.initial());
    });

    on<AppUnauthenticatedTabChanged>((event, emit) {
      assert(state is AppUnauthenticatedState);
      emit(AppUnauthenticatedState(tab: event.tab));
    });

    _authRepository.user.forEach((user) {
      if (user == null) {
        add(const AppUnauthenticatedEvent());
      } else {
        add(const AppAuthenticatedEvent());
      }
    });
  }

  final AuthRepository _authRepository;

  void authenticate() {
    add(const AppAuthenticatedEvent());
  }

  void signOut() {
    _authRepository.signOut();
  }

  void goToSignIn() {
    add(const AppUnauthenticatedTabChanged(tab: UnauthenticatedTabs.signin));
  }

  void goToSignUp() {
    add(const AppUnauthenticatedTabChanged(tab: UnauthenticatedTabs.signup));
  }
}
