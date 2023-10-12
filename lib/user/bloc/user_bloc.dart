import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dating/preferences/preferences.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<_UserEvent, UserState> {
  UserBloc({required Profile profile}) : super(UserState(profile: profile)) {
    // --- LOAD PHOTOS
    on<_LoadPhotos>(_onLoadPhotos);

    // --- LOAD PROFILE
    on<_FetchUserProfile>(_onFetchUserProfile);

    // --- CHANGE PREFERENCES
    on<_ChangePrefs>(_onChangePrefs);

    // --- UPLOAD PHOTO
    on<_UploadPhoto>(_onUploadPhoto);

    // --- DELETE PHOTO
    on<_DeletePhoto>(_onDeletePhoto);
  }

  static UserBloc of(BuildContext context) => context.read<UserBloc>();

  // ---
  // --- LOAD PHOTOS
  // ---
  FutureOr<void> _onLoadPhotos(
    _LoadPhotos event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true));

      final photos = await supabaseService.photosByUserId();

      emit(state.copyWith(
          loading: false, profile: state.profile.copyWith(photos: photos)));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
      debugPrint(e.toString());
    }
  }

  // ---
  // --- FETCH USER PROFILE
  // ---
  FutureOr<void> _onFetchUserProfile(
    _FetchUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final profile = await supabaseService.fetchUserProfile();

    if (profile != null) {
      emit(state.copyWith(loading: false, profile: profile));
    } else {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // ---
  // --- UPLOAD PHOTO
  // ---
  FutureOr<void> _onUploadPhoto(
    _UploadPhoto event,
    Emitter<UserState> emit,
  ) async {
    await supabaseService.uploadPhoto(bytes: event.bytes);
    final photos = await supabaseService.photosByUserId();
    if (photos != null) {
      emit(state.copyWith(profile: state.profile.copyWith(photos: photos)));
    }
  }

  // ---
  // --- DELETE PHOTO
  // ---
  FutureOr<void> _onDeletePhoto(
    _DeletePhoto event,
    Emitter<UserState> emit,
  ) async {
    final photoId = state.profile.photos[state.curPhotoIndex].id;
    final ok = await supabaseService.deletePhoto(photoId);

    if (ok == true) {
      // ignore: no_leading_underscores_for_local_identifiers
      var _state = state.excludePhoto();
      _state = _state.copyWith(curPhotoIndex: max(_state.curPhotoIndex - 1, 0));

      emit(_state);
    }
  }

  // ---
  // --- CHANGE PREFERENCES
  // ---
  FutureOr<void> _onChangePrefs(
    _ChangePrefs event,
    Emitter<UserState> emit,
  ) async {
    if (state.profile == null) return;

    final oldPrefs = state.profile.prefs;
    bool? result;

    final prefs = switch (event.name) {
      'alcohol' => oldPrefs.copyWith(
          alcohol: PrefsAlcohol.values[event.value],
        ),
      'children' => oldPrefs.copyWith(
          children: PrefsChildren.values[event.value],
        ),
      'education' => oldPrefs.copyWith(
          education: PrefsEducation.values[event.value],
        ),
      'looking_for' => oldPrefs.copyWith(
          lookingFor: PrefsLookingFor.values[event.value],
        ),
      'love_lang' => oldPrefs.copyWith(
          lovelang: PrefsLoveLanguage.values[event.value],
        ),
      'nutrition' => oldPrefs.copyWith(
          nutrition: PrefsNutrition.values[event.value],
        ),
      'pets' => oldPrefs.copyWith(
          pets: PrefsPets.values[event.value],
        ),
      'smoking' => oldPrefs.copyWith(
          smoking: PrefsSmoking.values[event.value],
        ),
      'workout' => oldPrefs.copyWith(
          workout: PrefsWorkout.values[event.value],
        ),
      _ => throw Exception('wrong pref type')
    };

    emit(state.copyWith(profile: state.profile.copyWith(prefs: prefs)));
    result = await supabaseService.updatePrefs(prefs);

    if (result != true) {
      emit(state.copyWith(profile: state.profile.copyWith(prefs: oldPrefs)));
    }
  }

  // ---
  // --- PUBLIC API
  // ---
  uploadPhoto(Uint8List bytes) {
    add(_UploadPhoto(bytes: bytes));
  }

  deletePhoto() {
    add(const _DeletePhoto());
  }

  changePref(String prefName, int prefValue) {
    add(_ChangePrefs(name: prefName, value: prefValue));
  }

  loadPhotos() {
    add(const _LoadPhotos());
  }

  fetchUserProfile() {
    add(const _FetchUserProfile());
  }
}
