import 'package:collection/collection.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<_ProfilesEvent, ProfilesState> {
  ProfilesBloc() : super(const ProfilesState()) {
    on<_FetchCardsProfiles>(_onFetchCardsProfiles);
    on<_FetchProfile>(_onFetchProfile);
    on<_LikePhoto>(_onLikePhoto);
    on<_FetchProfiles>(_onFetchProfiles);
  }

  static ProfilesBloc of(BuildContext context) => context.read<ProfilesBloc>();

  // ---
  // --- FETCH CARDS PROFILES
  // ---
  _onFetchCardsProfiles(
    _FetchCardsProfiles event,
    Emitter<ProfilesState> emit,
  ) async {
    emit(state.copyWith(loading: LoadingStatus.loading));

    final profiles = await supabaseService.fetchCardsProfiles();

    if (profiles != null) {
      emit(
        state.upsertProfiles(profiles).copyWith(loading: LoadingStatus.loaded),
      );
    } else {
      emit(state.copyWith(loading: LoadingStatus.failure));
    }
  }

  // ---
  // --- FETCH SINGLE PROFILE
  // ---
  _onFetchProfile(
    _FetchProfile event,
    Emitter<ProfilesState> emit,
  ) async {
    emit(state.updateLoadingStatus(event.profileId, LoadingStatus.loading));

    final profile = await supabaseService.fetchProfile(event.profileId);

    if (profile != null) {
      emit(state.upsertProfiles([profile]).updateLoadingStatus(
        event.profileId,
        LoadingStatus.loaded,
      ));
    } else {
      emit(state.updateLoadingStatus(event.profileId, LoadingStatus.failure));
    }
  }

  // ---
  // --- FETCH MANY PROFILES
  // ---
  _onFetchProfiles(_FetchProfiles event, Emitter<ProfilesState> emit) async {
    final profileIds =
        event.profileIds.whereNot(state.profiles.contains).toList();

    if (profileIds.isEmpty) return;

    final profiles = await supabaseService.fetchProfiles(profileIds);

    if (profiles != null) {
      emit(state.upsertProfiles(profiles));
    }
  }

  // ---
  // --- LIKE PHOTO
  // ---
  _onLikePhoto(_LikePhoto event, Emitter<ProfilesState> emit) async {
    if (globalUser?.id == null) return;

    final profile = state.getProfile(event.profileId);
    if (profile == null) return;

    final photo = profile.getPhoto(event.photoId);
    if (photo == null) return;

    final oldProfiles = state.profiles;

    Profile newProfile;
    bool? ok;

    final liked = photo.likes.contains(requireUser.id);

    if (liked) {
      newProfile = profile.copyWith(
        photos: profile.photos.updateWhere(
          (photo) => photo.unliked(globalUser!.id),
          (photo) => photo.id == event.photoId,
        ),
      );
    } else {
      newProfile = profile.copyWith(
        photos: profile.photos.updateWhere(
          (photo) => photo.liked(globalUser!.id),
          (photo) => photo.id == event.photoId,
        ),
      );
    }

    final newProfiles = oldProfiles.upsertWhere(
      newProfile,
      (p) => p.userId == event.profileId,
    );

    emit(state.copyWith(profiles: newProfiles));

    if (liked) {
      ok = await supabaseService.unlikePhoto(event.photoId);
    } else {
      ok = await supabaseService.likePhoto(event.photoId, event.profileId);
    }

    if (ok != true) {
      emit(state.copyWith(profiles: oldProfiles));
    }
  }

  // ---
  // --- PUBLIC API
  // ---
  void fetchProfile(String id) {
    add(_FetchProfile(profileId: id));
  }

  void fetchProfiles(List<String> profileIds) {
    if (profileIds.isEmpty) return;
    add(_FetchProfiles(profileIds: profileIds));
  }

  void fetchCardsProfiles() {
    add(const _FetchCardsProfiles());
  }

  void likePhoto(String profileId, String photoId) {
    add(_LikePhoto(profileId: profileId, photoId: photoId));
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
