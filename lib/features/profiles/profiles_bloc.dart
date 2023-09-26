import 'package:collection/collection.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<_ProfilesEvent, ProfilesState> {
  ProfilesBloc() : super(const ProfilesState()) {
    on<_LoadAll>(_onLoadAll);
    on<_LoadCertain>(_onLoadCertain);

    loadAll();
  }

  // --- LOAD ALL PROFILES
  _onLoadAll(_LoadAll event, Emitter<ProfilesState> emit) async {
    try {
      emit(state.copyWith(loading: LoadingStatus.loading));

      final profiles = await supabaseService.findAllProfiles();

      emit(state
          .upsertProfiles(profiles)
          .copyWith(loading: LoadingStatus.loaded));
      // ---
    } catch (e) {
      emit(state.copyWith(loading: LoadingStatus.failure));
      debugPrint(e.toString());
    }
  }

  // --- LOAD CERTAIN PROFILE
  _onLoadCertain(_LoadCertain event, Emitter<ProfilesState> emit) async {
    final id = event.profileId;

    try {
      emit(state.updateLoadingStatus(id, LoadingStatus.loading));
      final profile =
          await supabaseService.findProfileByUserId(event.profileId);

      if (profile != null) {
        emit(state.upsertProfiles([profile]).updateLoadingStatus(
            id, LoadingStatus.loaded));
      }
    } catch (e) {
      emit(state.updateLoadingStatus(id, LoadingStatus.failure));
      debugPrint(e.toString());
    }
  }

  // --- PUBLIC API
  void loadCertain(String id) {
    add(_LoadCertain(profileId: id));
  }

  void loadAll() {
    add(const _LoadAll());
  }

  // // --- JSON SERIALIZING
  // @override
  // ProfilesState? fromJson(Map<String, dynamic> json) => ProfilesState(
  //       profiles: (json['profiles'] as List)
  //           .map((profile) => Profile.fromJson(profile))
  //           .toList(),
  //     );

  // @override
  // Map<String, dynamic>? toJson(ProfilesState state) => {
  //       'profiles': state.profiles.map((profile) => profile.toJson()).toList(),
  //     };
}
