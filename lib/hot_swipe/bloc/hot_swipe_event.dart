part of 'hot_swipe_bloc.dart';

sealed class _HotSwipeEvent {
  const _HotSwipeEvent();
}

final class _LikeHotSwipeEvent extends _HotSwipeEvent {
  const _LikeHotSwipeEvent();
}

final class _DismissHotSwipeEvent extends _HotSwipeEvent {
  const _DismissHotSwipeEvent();
}
