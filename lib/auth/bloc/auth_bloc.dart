import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<_AuthEvent, AuthState> {
  AuthBloc({
    String? countryCode,
  }) : super(AuthState(screen: AuthScreen.signin, countryCode: countryCode)) {
    on<_GoToSignIn>(
      (event, emit) {
        emit(state.toSignIn());
      },
    );

    on<_GoToSignUp>(
      (event, emit) {
        emit(state.toSignUp());
      },
    );

    on<_Authenticated>((event, emit) {
      emit(state.toAuthenticated(event.profile));
    });

    on<_SignInWithGoogle>(_onSignInWithGoogle);
    on<_SignInWithFacebook>(_onSignInWithFacebook);
  }

  static AuthBloc of(BuildContext context) => context.read<AuthBloc>();

  // ---
  // --- SIGN IN WITH GOOGLE
  // ---
  _onSignInWithGoogle(
    _SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    final ok = await supabaseService.signInWithGoogle();

    if (ok == true) {
      final profile = await supabaseService.fetchUserProfile();

      emit(state.toAuthenticated(profile));
    }
  }

  _onSignInWithFacebook(
    _SignInWithFacebook event,
    Emitter<AuthState> emit,
  ) async {
    final ok = await supabaseService.signInWithFacebook();

    if (ok == true) {
      final profile = await supabaseService.fetchUserProfile();

      emit(state.toAuthenticated(profile));
    }
  }

  // ---
  // --- PUBLIC API
  // ---

  void goToSignIn() {
    add(const _GoToSignIn());
  }

  void goToSignUp() {
    add(const _GoToSignUp());
  }

  void authenticate(Profile? profile) {
    add(_Authenticated(profile: profile));
  }

  void signInWithGoogle() {
    add(const _SignInWithGoogle());
  }

  void signInWithFacebook() {
    add(const _SignInWithFacebook());
  }
}
