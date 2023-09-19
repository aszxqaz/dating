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
        final photos = await supabaseService.findPhotosByUserId();
        debugPrint('FETCHED PHOTOS');

        // await supabaseService.findAllProfiles();
        emit(state.copyWith(loading: false, photos: photos));
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
        debugPrint(e.toString());
      }
    });
  }

  loadPhotos() {
    add(const LoadPhotosUserEvent());
  }

  listen() {
    supabaseService.listenUpdates();
  }
}
