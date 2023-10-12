import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hot_cards_event.dart';
part 'hot_cards_state.dart';

class HotCardsBloc extends Bloc<_HotCardsEvent, HotState> {
  HotCardsBloc() : super(HotState.initialLoading) {
    on<_LoadProfilesHotCardsEvent>((_, emit) async {
      try {
        final profiles = await supabaseService.fetchCardsProfiles();
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
    add(const _LoadProfilesHotCardsEvent());
  }
}
