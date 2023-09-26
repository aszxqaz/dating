import 'package:dating/hot/models/hot_card.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hot_event.dart';
part 'hot_state.dart';

class HotBloc extends Bloc<HotEvent, HotState> {
  HotBloc() : super(HotState.initialLoading) {
    on<LoadProfilesHotEvent>((_, emit) async {
      try {
        final profiles = await supabaseService.findAllProfiles();
        emit(
          state.copyWith(
            loading: false,
            profiles: profiles,
          ),
        );
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
        debugPrint(e.toString());
      }
    });
  }

  loadCards() {
    add(const LoadProfilesHotEvent());
  }
}
