import 'dart:async';
import 'dart:io';

import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<_AppEvent, AppState> {
  AppBloc() : super(const AppLoadingState()) {
    on<_Authenticated>(_onAuthenticated);
    on<_Unauthenticated>(_onUnauthenticated);
    on<_Incompleted>(_onIncompleted);

    _initApp();
  }

  static AppBloc of(BuildContext context) => context.read<AppBloc>();

  StreamSubscription<AuthState>? _authStateSubscription;

  // ---
  // --- LIFECYCLE
  // ---
  @override
  Future<void> close() async {
    _authStateSubscription?.cancel();
    super.close();
  }

  // ---
  // --- HELPER METHODS
  // ---
  _initApp() async {
    final user = supabaseClient.auth.currentUser;

    debugPrint('[AppBloc] _initApp() user id: ${user?.id}');

    final event =
        user == null ? AuthChangeEvent.signedOut : AuthChangeEvent.signedIn;

    await _handleAuthChange(event, user);

    _subscribeAuthState();
  }

  void _subscribeAuthState() {
    _authStateSubscription = supabaseService.authChange.listen((authState) =>
        _handleAuthChange(authState.event, authState.session?.user));
  }

  Future<void> _handleAuthChange(AuthChangeEvent event, User? user) async {
    switch (event) {
      case AuthChangeEvent.signedIn:
        globalUser = user;
        final profile = await supabaseService.fetchUserProfile();

        if (Platform.isAndroid) {
          OneSignal.User.addAlias('user_id', user!.id);
        }

        if (profile != null) {
          add(_Authenticated(profile: profile));
        } else {
          add(const _Incompleted());
        }

      case AuthChangeEvent.signedOut:
      case AuthChangeEvent.userDeleted:
        globalUser = null;
        final countryCode = await _getCountryCode();
        add(_Unauthenticated(countryCode: countryCode));
      default:
        return;
    }
  }

  Future<String?> _getCountryCode() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }
    return await FlutterSimCountryCode.simCountryCode;
  }

  String? countryCode;

  // ---
  // --- EVENT HANDLER: AUTHENTICATED
  // ---
  void _onAuthenticated(_Authenticated event, Emitter<AppState> emit) {
    emit(AppAuthenticatedState(profile: event.profile));
  }

  // ---
  // --- EVENT HANDLER: UNAUTHENTICATED
  // ---
  void _onUnauthenticated(_Unauthenticated event, Emitter<AppState> emit) {
    emit(AppUnauthenticatedState(countryCode: event.countryCode));
  }

  // ---
  // --- EVENT HANDLER: INCOMPLETED
  // ---
  void _onIncompleted(_Incompleted event, Emitter<AppState> emit) {
    emit(const AppIncompletedState());
  }

  // ---
  // --- PUBLIC API
  // ---
  void authenticate(Profile? profile) {
    if (profile != null) {
      add(_Authenticated(profile: profile));
    } else {
      add(const _Incompleted());
    }
  }

  void signOut() {
    supabaseService.signOut();
  }

  void submitComplete(String name, DateTime birthdate) {
    add(_SubmitIncomplete(name: name, birthdate: birthdate));
  }
}
