part of 'hot_cards_bloc.dart';

sealed class _HotCardsEvent {
  const _HotCardsEvent();
}

final class _LoadProfilesHotCardsEvent extends _HotCardsEvent {
  const _LoadProfilesHotCardsEvent();
}
