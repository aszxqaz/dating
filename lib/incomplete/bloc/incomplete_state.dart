part of 'incomplete_bloc.dart';

enum IncompleteStage { birthdate, gender, name }

extension IncompleteStageExt on IncompleteStage {
  bool get isLast => index == IncompleteStage.values.length - 1;
}

class IncompleteState {
  const IncompleteState({
    this.stage = IncompleteStage.birthdate,
    this.birthdate,
    this.name = '',
    this.fieldErrors = const {},
    this.error,
    this.profile,
    this.loading = false,
    this.gender = Gender.male,
  });

  final IncompleteStage stage;
  final DateTime? birthdate;
  final Gender gender;
  final String name;
  final Map<String, String?> fieldErrors;
  final String? error;
  final Profile? profile;
  final bool loading;

  IncompleteState copyWith({
    IncompleteStage? stage,
    Gender? gender,
    String? name,
    Map<String, String?>? fieldErrors,
    String? error,
    Profile? profile,
    bool? loading,
  }) =>
      IncompleteState(
        gender: gender ?? this.gender,
        stage: stage ?? this.stage,
        birthdate: birthdate,
        name: name ?? this.name,
        fieldErrors: fieldErrors ?? this.fieldErrors,
        error: error ?? this.error,
        profile: profile ?? this.profile,
        loading: loading ?? this.loading,
      );

  withFieldErrors(Map<String, String> errors) => copyWith(
        fieldErrors: {
          ...fieldErrors,
          ...errors,
        },
        loading: false,
      );

  toGenderStage(DateTime birthdate) => IncompleteState(
        birthdate: birthdate,
        stage: IncompleteStage.gender,
      );

  toNameStage(Gender gender) => IncompleteState(
        birthdate: birthdate,
        gender: gender,
        stage: IncompleteStage.name,
      );

  withError(String error) => copyWith(
        error: error,
        loading: false,
      );

  withBirthdate(DateTime? birthdate) => IncompleteState(
        birthdate: birthdate,
        name: name,
        gender: gender,
        fieldErrors: fieldErrors,
        stage: stage,
      );
}
