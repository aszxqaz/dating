part of 'incomplete_bloc.dart';

sealed class _IncompleteEvent {
  const _IncompleteEvent();
}

class _Submit extends _IncompleteEvent {
  const _Submit();
}

class _ToStage extends _IncompleteEvent {
  const _ToStage({required this.stage});

  final IncompleteStage stage;
}

class _ValueChanged extends _IncompleteEvent {
  const _ValueChanged({
    required this.stage,
    this.name,
    this.birthdate,
    this.gender,
  });

  final IncompleteStage stage;
  final String? name;
  final DateTime? birthdate;
  final Gender? gender;
}
