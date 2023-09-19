import 'package:dating/supabase/auth_service.dart';
import 'package:dating/supabase/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppUnauthenticatedState.initial) {
    on<AppAuthenticatedEvent>((event, emit) {
      emit(const AppAuthenticatedState());
    });

    on<AppUnauthenticatedEvent>((event, emit) {
      emit(AppUnauthenticatedState.initial);
    });

    on<AppUnauthenticatedTabChanged>((event, emit) {
      assert(state is AppUnauthenticatedState);
      emit(AppUnauthenticatedState(tab: event.tab));
    });

    supabaseClient.auth.onAuthStateChange.listen((data) {
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          add(const AppAuthenticatedEvent());
        case AuthChangeEvent.signedOut:
          add(const AppUnauthenticatedEvent());
        default:
      }
    });
  }

  void authenticate() {
    add(const AppAuthenticatedEvent());
  }

  void signOut() {
    authService.signOut();
  }

  void goToSignIn() {
    add(const AppUnauthenticatedTabChanged(tab: UnauthenticatedTabs.signin));
  }

  void goToSignUp() {
    add(const AppUnauthenticatedTabChanged(tab: UnauthenticatedTabs.signup));
  }
}
