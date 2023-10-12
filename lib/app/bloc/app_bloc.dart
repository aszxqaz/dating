import 'dart:async';

import 'package:dating/supabase/auth_service.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppUnauthenticatedState.initial) {
    on<AppUnauthenticatedTabChanged>((event, emit) {
      assert(state is AppUnauthenticatedState);
      emit(AppUnauthenticatedState(tab: event.tab));
    });

    on<AppAuthStateChanged>(_onAppAuthStateChanged);
    on<AppSubmitIncomplete>(_onAppSubmitIncomplete);

    _subscribeAuthState();
  }

  StreamSubscription<AuthState>? _authStateSubscription;

  // ---
  // --- AUTH STATE CHANGED
  // ---
  FutureOr<void> _onAppAuthStateChanged(
    AppAuthStateChanged event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppLoadingState());

    switch (event.event) {
      case AuthChangeEvent.signedIn:
        final profile = await supabaseService.fetchUserProfile();

        debugPrint('_onAppAuthStateChanged [profile]: ${profile.toString()}');

        if (profile == null) {
          String? countryCode;

          countryCode = await FlutterSimCountryCode.simCountryCode;
          debugPrint('Country code: $countryCode');

          emit(AppIncompleteState(countryCode: countryCode));
        } else {
          emit(AppAuthenticatedState(profile: profile));
        }

      case AuthChangeEvent.signedOut:
        emit(AppUnauthenticatedState.initial);

      default:
        return;
    }
  }

  // ---
  // --- SUBMIT NAME AND BIRTHDATE
  // ---
  FutureOr<void> _onAppSubmitIncomplete(
    AppSubmitIncomplete event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppLoadingState());

    final profile =
        await supabaseService.createProfile(event.birthdate, event.name);

    if (profile != null) {
      emit(AppAuthenticatedState(profile: profile));
    } else {
      emit(const AppIncompleteState());
    }
  }

  void _subscribeAuthState() {
    _authStateSubscription =
        supabaseClient.auth.onAuthStateChange.listen((data) {
      add(AppAuthStateChanged(event: data.event));
    });
  }

  @override
  Future<void> close() async {
    _authStateSubscription?.cancel();
    super.close();
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

  void submitComplete(String name, DateTime birthdate) {
    add(AppSubmitIncomplete(name: name, birthdate: birthdate));
  }
}
