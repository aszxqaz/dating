part of 'hot_bloc.dart';

sealed class HotEvent {
  const HotEvent();
}

final class LoadProfilesHotEvent extends HotEvent {
  const LoadProfilesHotEvent();
}
