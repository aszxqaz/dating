part of 'hot_swipe_bloc.dart';

enum HotSwipeAction { none, like, dismiss }

extension WhatIs on HotSwipeAction {
  bool get isNone => this == HotSwipeAction.none;
  bool get isLike => this == HotSwipeAction.like;
  bool get isDismiss => this == HotSwipeAction.dismiss;
}

class HotSwipeState {
  HotSwipeState({required this.profiles});

  factory HotSwipeState.fromProfiles(List<Profile> profiles) => HotSwipeState(
      profiles: profiles.map(HotSwipeProfile.fromProfile).toList());

  final List<HotSwipeProfile> profiles;

  HotSwipeProfile? get current => profiles.firstOrNull;
  HotSwipeProfile? get next => profiles.length > 1 ? profiles[1] : null;

  HotSwipeState copyWith({List<HotSwipeProfile>? profiles}) =>
      HotSwipeState(profiles: profiles ?? this.profiles);
}

class HotSwipeProfile {
  const HotSwipeProfile({
    required this.profile,
    required this.action,
  });

  factory HotSwipeProfile.fromProfile(Profile profile) => HotSwipeProfile(
        profile: profile,
        action: HotSwipeAction.none,
      );

  final Profile profile;
  final HotSwipeAction action;

  HotSwipeProfile copyWith({HotSwipeAction? action}) => HotSwipeProfile(
        profile: profile,
        action: action ?? this.action,
      );
}
