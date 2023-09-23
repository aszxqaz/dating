import 'package:dating/preferences/preferences.dart';
import 'package:dating/supabase/models/model.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState.initialLoading) {
    on<LoadPhotosUserEvent>((_, emit) async {
      try {
        emit(state.copyWith(loading: true));

        final photos = await supabaseService.findPhotosByUserId();

        emit(state.copyWith(loading: false, photos: photos));
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
        debugPrint(e.toString());
      }
    });

    on<LoadProfilesUserEvent>((_, emit) async {
      try {
        emit(state.copyWith(loading: true));

        final profile = await supabaseService.findProfileByUserId();
        debugPrint('FETCHED PROFILE: ${profile.toString()}');

        emit(state.copyWith(loading: false, profile: profile));
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
        debugPrint(e.toString());
      }
    });

    on<ChangePrefUserEvent>((event, emit) async {
      if (state.profile == null) return;

      final oldPrefs = state.profile!.prefs;
      bool result = false;

      final prefs = switch (event.name) {
        'alcohol' => oldPrefs.copyWith(
            alcohol:
                event.value == null ? null : PrefsAlcohol.values[event.value!],
          ),
        'children' => oldPrefs.copyWith(
            children:
                event.value == null ? null : PrefsChildren.values[event.value!],
          ),
        'education' => oldPrefs.copyWith(
            education: event.value == null
                ? null
                : PrefsEducation.values[event.value!],
          ),
        'looking_for' => oldPrefs.copyWith(
            lookingFor: event.value == null
                ? null
                : PrefsLookingFor.values[event.value!],
          ),
        'love_lang' => oldPrefs.copyWith(
            lovelang: event.value == null
                ? null
                : PrefsLoveLanguage.values[event.value!],
          ),
        'nutrition' => oldPrefs.copyWith(
            nutrition: event.value == null
                ? null
                : PrefsNutrition.values[event.value!],
          ),
        'pets' => oldPrefs.copyWith(
            pets: event.value == null ? null : PrefsPets.values[event.value!],
          ),
        'smoking' => oldPrefs.copyWith(
            smoking:
                event.value == null ? null : PrefsSmoking.values[event.value!],
          ),
        'workout' => oldPrefs.copyWith(
            workout:
                event.value == null ? null : PrefsWorkout.values[event.value!],
          ),
        _ => throw Exception('wrong pref type')
      };

      emit(state.copyWith(profile: state.profile!.copyWith(prefs: prefs)));
      result = await supabaseService.updatePrefs(prefs);

      if (!result) {
        emit(state.copyWith(profile: state.profile!.copyWith(prefs: oldPrefs)));
      }
    });
  }

  changePref(String prefName, int? prefValue) {
    add(ChangePrefUserEvent(name: prefName, value: prefValue));
  }

  loadPhotos() {
    add(const LoadPhotosUserEvent());
  }

  loadProfile() {
    add(const LoadProfilesUserEvent());
  }

  listen() {
    supabaseService.listenUpdates();
  }
}
