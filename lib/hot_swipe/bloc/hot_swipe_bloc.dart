import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dating/supabase/models/models.dart';

part 'hot_swipe_event.dart';
part 'hot_swipe_state.dart';

class HotSwipeBloc extends Bloc<_HotSwipeEvent, HotSwipeState> {
  HotSwipeBloc({required List<Profile> profiles})
      : super(HotSwipeState.fromProfiles(profiles)) {
    /// ---
    on<_LikeHotSwipeEvent>(_onLikeHotSwipeEvent);
    on<_DismissHotSwipeEvent>(_onDismissHotSwipeEvent);
  }

  _onLikeHotSwipeEvent(_LikeHotSwipeEvent event, Emitter emit) {
    final profile = state.current;
    if (profile == null) return;

    final liked = profile.copyWith(action: HotSwipeAction.like);

    final profiles = state.profiles.slice(1) + [liked];

    emit(state.copyWith(profiles: profiles));
  }

  _onDismissHotSwipeEvent(_DismissHotSwipeEvent event, Emitter emit) {
    final profile = state.current;
    if (profile == null) return;

    final dismissed = profile.copyWith(action: HotSwipeAction.dismiss);

    final profiles = state.profiles.slice(1) + [dismissed];

    emit(state.copyWith(profiles: profiles));
  }

  // --- PUBLIC API
  like() {
    add(const _LikeHotSwipeEvent());
  }

  dismiss() {
    add(const _DismissHotSwipeEvent());
  }
}
